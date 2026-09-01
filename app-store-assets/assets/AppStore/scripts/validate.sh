#!/usr/bin/env bash
set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
app_store_root="$(cd "$script_directory/.." && pwd)"
strict_ocr="${APPSTORE_STRICT_OCR:-1}"

swift "$script_directory/validate.swift" "$app_store_root"

if [[ "$strict_ocr" == "0" ]]; then
  echo "App Store structural validation passed; OCR explicitly disabled for this non-release run."
  exit 0
fi

if ! command -v tesseract >/dev/null 2>&1; then
  echo "App Store asset validation failed: tesseract is required for strict OCR checks." >&2
  exit 1
fi

if ! command -v rg >/dev/null 2>&1; then
  echo "App Store asset validation failed: rg is required for strict OCR checks." >&2
  exit 1
fi

ocr_directory="$(mktemp -d "${TMPDIR:-/tmp}/app-store-assets-ocr.XXXXXX")"
trap 'rm -rf "$ocr_directory"' EXIT

pattern_file="$ocr_directory/forbidden-patterns.txt"
python3 - "$app_store_root/screenshots.json" "$pattern_file" <<'PY'
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
patterns = manifest.get("forbiddenOCRPatterns", [])
Path(sys.argv[2]).write_text("\n".join(patterns) + ("\n" if patterns else ""), encoding="utf-8")
PY

while IFS= read -r -d '' image; do
  text_file="$ocr_directory/$(printf '%s' "$image" | shasum -a 256 | awk '{print $1}')"
  tesseract "$image" "$text_file" --psm 11 >/dev/null 2>&1 || true
  if [[ -s "$pattern_file" ]] && rg -n -i -f "$pattern_file" "$text_file.txt" >/dev/null; then
    echo "App Store asset validation failed: OCR found forbidden demo or placeholder copy in $image" >&2
    rg -n -i -f "$pattern_file" "$text_file.txt" >&2
    exit 1
  fi
done < <(
  find "$app_store_root/sources" "$app_store_root/deliverables" \
    -type f -name '*.png' -print0 2>/dev/null | sort -z
)

echo "App Store strict OCR validation passed."
