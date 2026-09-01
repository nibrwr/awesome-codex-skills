#!/usr/bin/env swift

import Foundation
import ImageIO

struct Manifest: Decodable {
    let schemaVersion: Int
    let specification: Specification
    let platforms: [String: Bool]
    let locales: [String]
    let sets: [ScreenshotSet]
}

struct Specification: Decodable {
    let verifiedOn: String
    let url: String
}

struct ScreenshotSet: Decodable {
    let id: String
    let platform: String
    let width: Int
    let height: Int
    let shots: [String]
}

struct LocalizedCopy: Decodable {
    let locale: String
    let brand: String
    let shots: [String: ShotCopy]
}

struct ShotCopy: Decodable {
    let eyebrow: String
    let headline: String
    let subtitle: String
}

enum ValidationError: LocalizedError {
    case failures([String])

    var errorDescription: String? {
        switch self {
        case .failures(let failures): failures.joined(separator: "\n")
        }
    }
}

func decode<T: Decodable>(_ type: T.Type, from url: URL) throws -> T {
    try JSONDecoder().decode(type, from: Data(contentsOf: url))
}

func imageProperties(_ url: URL) -> (width: Int, height: Int, hasAlpha: Bool)? {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
          let width = properties[kCGImagePropertyPixelWidth] as? Int,
          let height = properties[kCGImagePropertyPixelHeight] as? Int else {
        return nil
    }
    let hasAlpha = properties[kCGImagePropertyHasAlpha] as? Bool ?? false
    return (width, height, hasAlpha)
}

let root: URL = {
    if CommandLine.arguments.count > 1 {
        return URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
    }
    return URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
}()

do {
    let manifest = try decode(Manifest.self, from: root.appendingPathComponent("screenshots.json"))
    var failures: [String] = []
    let fileManager = FileManager.default
    let shotPattern = try NSRegularExpression(pattern: #"^\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*$"#)
    let placeholderTokens = ["{APP_NAME}", "replace with", "supporting line", "real product story"]

    if manifest.schemaVersion != 1 {
        failures.append("Unsupported screenshots.json schemaVersion \(manifest.schemaVersion)")
    }
    if manifest.locales.isEmpty {
        failures.append("screenshots.json must declare at least one locale")
    }
    if Set(manifest.locales).count != manifest.locales.count {
        failures.append("screenshots.json contains duplicate locales")
    }
    if manifest.specification.url != "https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/" {
        failures.append("The specification URL must point to Apple’s current screenshot specifications")
    }

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    if let verified = formatter.date(from: manifest.specification.verifiedOn) {
        let age = Calendar(identifier: .gregorian).dateComponents([.day], from: verified, to: Date()).day ?? 0
        if age < -1 {
            failures.append("Apple screenshot specification verification date is in the future")
        }
        if age > 180 {
            failures.append("Apple screenshot specifications were last verified \(age) days ago; recheck them before release")
        }
    } else {
        failures.append("specification.verifiedOn must use YYYY-MM-DD")
    }

    for platform in ["iPhone", "iPad"] where manifest.platforms[platform] == true {
        if !manifest.sets.contains(where: { $0.platform == platform }) {
            failures.append("The app supports \(platform) but screenshots.json declares no \(platform) set")
        }
    }
    if !manifest.sets.contains(where: { manifest.platforms[$0.platform] == true }) {
        failures.append("screenshots.json contains no enabled screenshot sets")
    }

    for locale in manifest.locales {
        let copyURL = root.appendingPathComponent("copy/\(locale).json")
        guard fileManager.fileExists(atPath: copyURL.path) else {
            failures.append("Missing localized copy: \(copyURL.path)")
            continue
        }
        let copy = try decode(LocalizedCopy.self, from: copyURL)
        if copy.locale != locale {
            failures.append("\(copyURL.lastPathComponent) declares locale \(copy.locale)")
        }
        if copy.brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            failures.append("\(copyURL.lastPathComponent) has an empty brand")
        }
        let allCopy = ([copy.brand] + copy.shots.values.flatMap { [$0.eyebrow, $0.headline, $0.subtitle] })
            .joined(separator: " ")
            .lowercased()
        for token in placeholderTokens where allCopy.contains(token.lowercased()) {
            failures.append("\(copyURL.lastPathComponent) still contains template copy: \(token)")
        }

        for screenshotSet in manifest.sets where manifest.platforms[screenshotSet.platform] == true {
            if !(3...10).contains(screenshotSet.shots.count) {
                failures.append("\(locale)/\(screenshotSet.id) must declare between 3 and 10 screenshots")
            }
            if screenshotSet.width <= 0 || screenshotSet.height <= 0 {
                failures.append("\(screenshotSet.id) must declare positive pixel dimensions")
            }
            if Set(screenshotSet.shots).count != screenshotSet.shots.count {
                failures.append("\(locale)/\(screenshotSet.id) contains duplicate shot IDs")
            }

            let outputDirectory = root
                .appendingPathComponent("deliverables")
                .appendingPathComponent(locale)
                .appendingPathComponent(screenshotSet.id)
            let expectedNames = Set(screenshotSet.shots.map {
                "\($0)-\(screenshotSet.width)x\(screenshotSet.height).png"
            })
            let actualNames = Set(
                (try? fileManager.contentsOfDirectory(atPath: outputDirectory.path))?
                    .filter { $0.lowercased().hasSuffix(".png") } ?? []
            )
            for extra in actualNames.subtracting(expectedNames).sorted() {
                failures.append("Unexpected uploadable file: \(outputDirectory.appendingPathComponent(extra).path)")
            }

            for shotID in screenshotSet.shots {
                let range = NSRange(shotID.startIndex..., in: shotID)
                if shotPattern.firstMatch(in: shotID, range: range) == nil {
                    failures.append("Invalid shot ID \(shotID); use a two-digit prefix and lowercase kebab-case")
                }
                if copy.shots[shotID] == nil {
                    failures.append("Missing \(locale) copy for \(shotID)")
                } else if let shotCopy = copy.shots[shotID] {
                    let values = [shotCopy.eyebrow, shotCopy.headline, shotCopy.subtitle]
                    if values.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
                        failures.append("\(locale) copy for \(shotID) contains an empty field")
                    }
                }

                let source = root
                    .appendingPathComponent("sources")
                    .appendingPathComponent(locale)
                    .appendingPathComponent(screenshotSet.id)
                    .appendingPathComponent("\(shotID).png")
                if !fileManager.fileExists(atPath: source.path) {
                    failures.append("Missing source capture: \(source.path)")
                }

                let output = outputDirectory.appendingPathComponent(
                    "\(shotID)-\(screenshotSet.width)x\(screenshotSet.height).png"
                )
                guard let properties = imageProperties(output) else {
                    failures.append("Missing or unreadable deliverable: \(output.path)")
                    continue
                }
                if properties.width != screenshotSet.width || properties.height != screenshotSet.height {
                    failures.append(
                        "\(output.path) is \(properties.width)x\(properties.height); " +
                        "expected \(screenshotSet.width)x\(screenshotSet.height)"
                    )
                }
                if properties.hasAlpha {
                    failures.append("\(output.path) contains an alpha channel")
                }
            }
        }
    }

    if !failures.isEmpty {
        throw ValidationError.failures(failures.map { "- \($0)" })
    }
    let enabledSets = manifest.sets.filter { manifest.platforms[$0.platform] == true }
    let count = manifest.locales.reduce(0) { total, _ in
        total + enabledSets.reduce(0) { $0 + $1.shots.count }
    }
    print("App Store structural validation passed: \(count) deliverable(s), \(manifest.locales.count) locale(s)")
} catch {
    FileHandle.standardError.write(Data("App Store asset validation failed:\n\(error.localizedDescription)\n".utf8))
    exit(1)
}
