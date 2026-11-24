#!/usr/bin/env swift

import AppKit
import Foundation
import ImageIO

struct Manifest: Decodable {
    let platforms: [String: Bool]
    let locales: [String]
    let theme: Theme
    let sets: [ScreenshotSet]
}

struct Theme: Decodable {
    let backgroundTop: String
    let backgroundBottom: String
    let text: String
    let mutedText: String
    let accent: String
}

struct ScreenshotSet: Decodable {
    let id: String
    let platform: String
    let width: Int
    let height: Int
    let layout: Layout
    let shots: [String]
}

struct Layout: Decodable {
    let headerFraction: CGFloat
    let sideMarginFraction: CGFloat
    let deviceMaxWidthFraction: CGFloat
    let deviceMaxHeightFraction: CGFloat
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

enum ComposeError: LocalizedError {
    case message(String)

    var errorDescription: String? {
        switch self {
        case .message(let message): message
        }
    }
}

func decode<T: Decodable>(_ type: T.Type, from url: URL) throws -> T {
    try JSONDecoder().decode(type, from: Data(contentsOf: url))
}

func color(hex: String, alpha: CGFloat = 1) throws -> NSColor {
    let value = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
    guard value.count == 6, let rgb = Int(value, radix: 16) else {
        throw ComposeError.message("Invalid color \(hex)")
    }
    return NSColor(
        calibratedRed: CGFloat((rgb >> 16) & 0xff) / 255,
        green: CGFloat((rgb >> 8) & 0xff) / 255,
        blue: CGFloat(rgb & 0xff) / 255,
        alpha: alpha
    )
}

func loadImage(_ url: URL) throws -> CGImage {
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
        throw ComposeError.message("Could not read image at \(url.path)")
    }
    return image
}

func makeContext(width: Int, height: Int) throws -> CGContext {
    guard let context = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: width * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    ) else {
        throw ComposeError.message("Could not create \(width)x\(height) graphics context")
    }
    return context
}

func drawText(
    _ text: String,
    in rect: NSRect,
    font: NSFont,
    color: NSColor,
    alignment: NSTextAlignment = .left,
    lineHeight: CGFloat = 1
) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineBreakMode = .byWordWrapping
    paragraph.lineHeightMultiple = lineHeight
    NSAttributedString(
        string: text,
        attributes: [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph,
        ]
    ).draw(with: rect, options: [.usesLineFragmentOrigin, .usesFontLeading])
}

func render(
    root: URL,
    manifest: Manifest,
    screenshotSet: ScreenshotSet,
    locale: String,
    copy: LocalizedCopy,
    shotID: String
) throws {
    guard let shotCopy = copy.shots[shotID] else {
        throw ComposeError.message("Missing \(locale) copy for \(shotID)")
    }

    let framedURL = root
        .appendingPathComponent(".build/framed")
        .appendingPathComponent(locale)
        .appendingPathComponent(screenshotSet.id)
        .appendingPathComponent("\(shotID)_framed.png")
    let device = try loadImage(framedURL)
    let context = try makeContext(width: screenshotSet.width, height: screenshotSet.height)
    let width = CGFloat(screenshotSet.width)
    let height = CGFloat(screenshotSet.height)

    let topColor = try color(hex: manifest.theme.backgroundTop).cgColor
    let bottomColor = try color(hex: manifest.theme.backgroundBottom).cgColor
    guard let gradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: [bottomColor, topColor] as CFArray,
        locations: [0, 1]
    ) else {
        throw ComposeError.message("Could not create background gradient")
    }
    context.drawLinearGradient(
        gradient,
        start: CGPoint(x: width / 2, y: 0),
        end: CGPoint(x: width / 2, y: height),
        options: []
    )

    let accent = try color(hex: manifest.theme.accent)
    context.setFillColor(accent.withAlphaComponent(0.10).cgColor)
    context.fillEllipse(in: CGRect(x: width * 0.63, y: height * 0.67, width: width * 0.55, height: width * 0.55))
    context.setFillColor(accent.withAlphaComponent(0.07).cgColor)
    context.fillEllipse(in: CGRect(x: -width * 0.20, y: height * 0.08, width: width * 0.55, height: width * 0.55))

    let appKitContext = NSGraphicsContext(cgContext: context, flipped: false)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = appKitContext
    appKitContext.imageInterpolation = .high
    appKitContext.shouldAntialias = true

    let margin = width * screenshotSet.layout.sideMarginFraction
    let topMargin = height * 0.045
    let headerHeight = height * screenshotSet.layout.headerFraction
    let eyebrowHeight = max(34, width * 0.034)
    let headlineSize = width * (screenshotSet.platform == "iPad" ? 0.050 : 0.060)
    let subtitleSize = width * (screenshotSet.platform == "iPad" ? 0.021 : 0.026)
    let headlineHeight = headlineSize * 2.25
    let subtitleHeight = subtitleSize * 2.5
    let headerTop = height - topMargin

    context.setFillColor(accent.cgColor)
    context.fill(CGRect(x: margin, y: headerTop - 10, width: width * 0.12, height: max(6, width * 0.006)))

    drawText(
        "\(copy.brand.uppercased())  ·  \(shotCopy.eyebrow.uppercased())",
        in: NSRect(x: margin, y: headerTop - eyebrowHeight - 35, width: width - margin * 2, height: eyebrowHeight),
        font: .systemFont(ofSize: max(22, width * 0.020), weight: .semibold),
        color: accent
    )
    drawText(
        shotCopy.headline,
        in: NSRect(
            x: margin,
            y: headerTop - eyebrowHeight - headlineHeight - 58,
            width: width - margin * 2,
            height: headlineHeight
        ),
        font: .systemFont(ofSize: headlineSize, weight: .bold),
        color: try color(hex: manifest.theme.text),
        lineHeight: 0.94
    )
    drawText(
        shotCopy.subtitle,
        in: NSRect(
            x: margin,
            y: height - headerHeight + 16,
            width: width - margin * 2,
            height: subtitleHeight
        ),
        font: .systemFont(ofSize: subtitleSize, weight: .medium),
        color: try color(hex: manifest.theme.mutedText),
        lineHeight: 1.08
    )

    let sourceWidth = CGFloat(device.width)
    let sourceHeight = CGFloat(device.height)
    let maxDeviceWidth = width * screenshotSet.layout.deviceMaxWidthFraction
    let maxDeviceHeight = height * screenshotSet.layout.deviceMaxHeightFraction
    let scale = min(maxDeviceWidth / sourceWidth, maxDeviceHeight / sourceHeight)
    let deviceWidth = sourceWidth * scale
    let deviceHeight = sourceHeight * scale
    let deviceRect = CGRect(
        x: (width - deviceWidth) / 2,
        y: height * 0.025,
        width: deviceWidth,
        height: deviceHeight
    )
    context.saveGState()
    context.setShadow(
        offset: CGSize(width: 0, height: -max(10, width * 0.012)),
        blur: max(24, width * 0.028),
        color: NSColor.black.withAlphaComponent(0.20).cgColor
    )
    context.draw(device, in: deviceRect)
    context.restoreGState()
    NSGraphicsContext.restoreGraphicsState()

    guard let outputImage = context.makeImage() else {
        throw ComposeError.message("Could not create output for \(locale)/\(screenshotSet.id)/\(shotID)")
    }
    let outputDirectory = root
        .appendingPathComponent("deliverables")
        .appendingPathComponent(locale)
        .appendingPathComponent(screenshotSet.id)
    try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)
    let outputURL = outputDirectory.appendingPathComponent(
        "\(shotID)-\(screenshotSet.width)x\(screenshotSet.height).png"
    )
    guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, "public.png" as CFString, 1, nil) else {
        throw ComposeError.message("Could not create PNG destination at \(outputURL.path)")
    }
    CGImageDestinationAddImage(destination, outputImage, nil)
    guard CGImageDestinationFinalize(destination) else {
        throw ComposeError.message("Could not write \(outputURL.path)")
    }
    print("Composed \(outputURL.path)")
}

func makeContactSheet(
    root: URL,
    screenshotSet: ScreenshotSet,
    locale: String
) throws {
    let thumbnailWidth: CGFloat = screenshotSet.platform == "iPad" ? 360 : 280
    let thumbnailHeight = thumbnailWidth * CGFloat(screenshotSet.height) / CGFloat(screenshotSet.width)
    let gap: CGFloat = 24
    let headerHeight: CGFloat = 96
    let footerHeight: CGFloat = 38
    let width = Int(gap + CGFloat(screenshotSet.shots.count) * (thumbnailWidth + gap))
    let height = Int(headerHeight + thumbnailHeight + footerHeight)
    let context = try makeContext(width: width, height: height)
    context.setFillColor(NSColor(calibratedWhite: 0.97, alpha: 1).cgColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))

    let appKitContext = NSGraphicsContext(cgContext: context, flipped: false)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = appKitContext
    appKitContext.imageInterpolation = .high
    appKitContext.shouldAntialias = true
    drawText(
        "\(locale) · \(screenshotSet.id) · App Store sequence",
        in: NSRect(x: gap, y: CGFloat(height) - 68, width: CGFloat(width) - gap * 2, height: 42),
        font: .systemFont(ofSize: 28, weight: .semibold),
        color: .labelColor
    )

    for (index, shotID) in screenshotSet.shots.enumerated() {
        let file = root
            .appendingPathComponent("deliverables")
            .appendingPathComponent(locale)
            .appendingPathComponent(screenshotSet.id)
            .appendingPathComponent("\(shotID)-\(screenshotSet.width)x\(screenshotSet.height).png")
        let image = try loadImage(file)
        let x = gap + CGFloat(index) * (thumbnailWidth + gap)
        context.draw(
            image,
            in: CGRect(x: x, y: footerHeight, width: thumbnailWidth, height: thumbnailHeight)
        )
        drawText(
            String(format: "%02d", index + 1),
            in: NSRect(x: x, y: 8, width: thumbnailWidth, height: 24),
            font: .monospacedDigitSystemFont(ofSize: 18, weight: .semibold),
            color: .secondaryLabelColor
        )
    }
    NSGraphicsContext.restoreGraphicsState()

    guard let image = context.makeImage() else {
        throw ComposeError.message("Could not create contact sheet for \(locale)/\(screenshotSet.id)")
    }
    let outputDirectory = root.appendingPathComponent(".build/contact-sheets")
    try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)
    let output = outputDirectory.appendingPathComponent("\(locale)-\(screenshotSet.id).png")
    guard let destination = CGImageDestinationCreateWithURL(output as CFURL, "public.png" as CFString, 1, nil) else {
        throw ComposeError.message("Could not create contact sheet destination at \(output.path)")
    }
    CGImageDestinationAddImage(destination, image, nil)
    guard CGImageDestinationFinalize(destination) else {
        throw ComposeError.message("Could not write contact sheet at \(output.path)")
    }
    print("Composed \(output.path)")
}

do {
    let defaultRoot = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
    let root = CommandLine.arguments.count > 1
        ? URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
        : defaultRoot
    let manifest = try decode(Manifest.self, from: root.appendingPathComponent("screenshots.json"))

    for locale in manifest.locales {
        let copy = try decode(
            LocalizedCopy.self,
            from: root.appendingPathComponent("copy/\(locale).json")
        )
        guard copy.locale == locale else {
            throw ComposeError.message("copy/\(locale).json declares locale \(copy.locale)")
        }
        for screenshotSet in manifest.sets where manifest.platforms[screenshotSet.platform] == true {
            let outputDirectory = root
                .appendingPathComponent("deliverables")
                .appendingPathComponent(locale)
                .appendingPathComponent(screenshotSet.id)
            if let existing = try? FileManager.default.contentsOfDirectory(
                at: outputDirectory,
                includingPropertiesForKeys: nil
            ) {
                for file in existing where file.pathExtension.lowercased() == "png" {
                    try FileManager.default.removeItem(at: file)
                }
            }
            for shotID in screenshotSet.shots {
                try render(
                    root: root,
                    manifest: manifest,
                    screenshotSet: screenshotSet,
                    locale: locale,
                    copy: copy,
                    shotID: shotID
                )
            }
            try makeContactSheet(root: root, screenshotSet: screenshotSet, locale: locale)
        }
    }
} catch {
    FileHandle.standardError.write(Data("App Store composition failed: \(error.localizedDescription)\n".utf8))
    exit(1)
}
