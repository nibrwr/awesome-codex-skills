import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum AppDesign {
    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
    }

    enum Radius {
        static let compact: CGFloat = 8
        static let standard: CGFloat = 12
        static let prominent: CGFloat = 16
    }

    enum Metrics {
        static let macSidebarIdealWidth: CGFloat = 240
        static let macInspectorIdealWidth: CGFloat = 360
        static let macMinimumWindowWidth: CGFloat = 980
        static let macMinimumWindowHeight: CGFloat = 640
        static let touchTarget: CGFloat = 44
    }

    enum Typography {
        static let screenTitle = Font.title2.weight(.semibold)
        static let sectionTitle = Font.headline.weight(.semibold)
        static let body = Font.body
        static let detail = Font.subheadline
        static let metadata = Font.caption
        static let value = Font.title3.monospacedDigit().weight(.semibold)
        static let log = Font.system(.caption, design: .monospaced)
    }

    enum Palette {
        static var accent: Color { .accentColor }
        static var primaryText: Color { platformLabel }
        static var secondaryText: Color { platformSecondaryLabel }
        static var tertiaryText: Color { platformTertiaryLabel }
        static var separator: Color { platformSeparator }
        static var background: Color { platformBackground }
        static var groupedBackground: Color { platformGroupedBackground }
        static var controlBackground: Color { platformControlBackground }
        static var selectedFill: Color { accent.opacity(0.12) }
        static var accentBorder: Color { accent.opacity(0.28) }
        static var subtleShadow: Color { Color.black.opacity(0.05) }
        static var overlayBadgeFill: Color { Color.black.opacity(0.38) }

        static var positive: Color { .green }
        static var warning: Color { .orange }
        static var destructive: Color { .red }
    }

    enum Motion {
        static let quick = Animation.easeOut(duration: 0.12)
        static let standard = Animation.easeInOut(duration: 0.20)
    }
}

#if canImport(UIKit)
private var platformLabel: Color { Color(uiColor: .label) }
private var platformSecondaryLabel: Color { Color(uiColor: .secondaryLabel) }
private var platformTertiaryLabel: Color { Color(uiColor: .tertiaryLabel) }
private var platformSeparator: Color { Color(uiColor: .separator) }
private var platformBackground: Color { Color(uiColor: .systemBackground) }
private var platformGroupedBackground: Color { Color(uiColor: .secondarySystemGroupedBackground) }
private var platformControlBackground: Color { Color(uiColor: .tertiarySystemGroupedBackground) }
#elseif canImport(AppKit)
private var platformLabel: Color { Color(nsColor: .labelColor) }
private var platformSecondaryLabel: Color { Color(nsColor: .secondaryLabelColor) }
private var platformTertiaryLabel: Color { Color(nsColor: .tertiaryLabelColor) }
private var platformSeparator: Color { Color(nsColor: .separatorColor) }
private var platformBackground: Color { Color(nsColor: .windowBackgroundColor) }
private var platformGroupedBackground: Color { Color(nsColor: .underPageBackgroundColor) }
private var platformControlBackground: Color { Color(nsColor: .controlBackgroundColor) }
#else
private var platformLabel: Color { .primary }
private var platformSecondaryLabel: Color { .secondary }
private var platformTertiaryLabel: Color { .secondary.opacity(0.75) }
private var platformSeparator: Color { .secondary.opacity(0.35) }
private var platformBackground: Color { .clear }
private var platformGroupedBackground: Color { .clear }
private var platformControlBackground: Color { .clear }
#endif
