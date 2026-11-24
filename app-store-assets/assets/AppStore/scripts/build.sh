#!/usr/bin/env bash
set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
app_store_root="$(cd "$script_directory/.." && pwd)"

python3 "$script_directory/frame.py"
swift "$script_directory/compose.swift" "$app_store_root"
"$script_directory/validate.sh"

echo "App Store screenshot package is ready under $app_store_root/deliverables."
