import SwiftUI

enum AppSurfaceProminence {
    case standard
    case prominent
    case inset
}

struct AppSurfaceModifier: ViewModifier {
    let prominence: AppSurfaceProminence

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    func body(content: Content) -> some View {
        content
            .background(surfaceFill, in: shape)
            .overlay {
                shape.strokeBorder(borderColor, lineWidth: borderWidth)
            }
            .shadow(
                color: shadowColor,
                radius: prominence == .prominent ? 10 : 4,
                x: 0,
                y: prominence == .prominent ? 4 : 1
            )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
    }

    private var radius: CGFloat {
        switch prominence {
        case .standard:
            AppDesign.Radius.standard
        case .prominent:
            AppDesign.Radius.prominent
        case .inset:
            AppDesign.Radius.compact
        }
    }

    private var surfaceFill: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(AppDesign.Palette.controlBackground)
        }

        switch prominence {
        case .standard:
            return AnyShapeStyle(.regularMaterial)
        case .prominent:
            return AnyShapeStyle(.thickMaterial)
        case .inset:
            return AnyShapeStyle(.thinMaterial)
        }
    }

    private var borderColor: Color {
        AppDesign.Palette.separator.opacity(colorSchemeContrast == .increased ? 0.90 : 0.55)
    }

    private var borderWidth: CGFloat {
        colorSchemeContrast == .increased ? 1.5 : 1
    }

    private var shadowColor: Color {
        prominence == .prominent ? AppDesign.Palette.subtleShadow : AppDesign.Palette.subtleShadow.opacity(0.65)
    }
}

extension View {
    func appSurface(_ prominence: AppSurfaceProminence = .standard) -> some View {
        modifier(AppSurfaceModifier(prominence: prominence))
    }
}

struct AppPanel<Content: View>: View {
    let title: String
    var subtitle: String?
    var systemImage: String?
    var prominence: AppSurfaceProminence = .standard
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
            AppSectionHeader(title: title, subtitle: subtitle, systemImage: systemImage)
            content
        }
        .padding(AppDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appSurface(prominence)
    }
}

struct AppSectionHeader: View {
    let title: String
    var subtitle: String?
    var systemImage: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppDesign.Spacing.sm) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(AppDesign.Palette.accent)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: AppDesign.Spacing.xxs) {
                Text(title)
                    .font(AppDesign.Typography.sectionTitle)
                    .foregroundStyle(AppDesign.Palette.primaryText)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppDesign.Typography.detail)
                        .foregroundStyle(AppDesign.Palette.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: AppDesign.Spacing.sm)
        }
    }
}

enum AppStatusTone {
    case neutral
    case accent
    case positive
    case warning
    case destructive

    var color: Color {
        switch self {
        case .neutral:
            AppDesign.Palette.secondaryText
        case .accent:
            AppDesign.Palette.accent
        case .positive:
            AppDesign.Palette.positive
        case .warning:
            AppDesign.Palette.warning
        case .destructive:
            AppDesign.Palette.destructive
        }
    }

    var defaultSymbolName: String {
        switch self {
        case .neutral:
            "circle"
        case .accent:
            "info.circle.fill"
        case .positive:
            "checkmark.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        case .destructive:
            "xmark.octagon.fill"
        }
    }
}

struct AppStatusBadge: View {
    let text: String
    var tone: AppStatusTone = .neutral
    var systemImage: String?

    var body: some View {
        Label(text, systemImage: systemImage ?? tone.defaultSymbolName)
            .font(AppDesign.Typography.metadata.weight(.semibold))
            .foregroundStyle(tone.color)
            .padding(.horizontal, AppDesign.Spacing.sm)
            .padding(.vertical, AppDesign.Spacing.xs)
            .background(tone.color.opacity(0.12), in: Capsule(style: .continuous))
            .accessibilityElement(children: .combine)
    }
}

struct AppEmptyStateView: View {
    let title: String
    let message: String
    var systemImage: String = "tray"

    var body: some View {
        VStack(spacing: AppDesign.Spacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(AppDesign.Palette.secondaryText)
                .accessibilityHidden(true)

            Text(title)
                .font(AppDesign.Typography.sectionTitle)
                .foregroundStyle(AppDesign.Palette.primaryText)

            Text(message)
                .font(AppDesign.Typography.detail)
                .foregroundStyle(AppDesign.Palette.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(AppDesign.Spacing.xl)
        .accessibilityElement(children: .combine)
    }
}

struct AppPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .frame(minHeight: AppDesign.Metrics.touchTarget)
            .padding(.horizontal, AppDesign.Spacing.md)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: AppDesign.Radius.standard, style: .continuous)
                    .fill(AppDesign.Palette.accent.opacity(configuration.isPressed ? 0.78 : 1))
            )
    }
}

struct AppSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .frame(minHeight: AppDesign.Metrics.touchTarget)
            .padding(.horizontal, AppDesign.Spacing.md)
            .foregroundStyle(AppDesign.Palette.primaryText.opacity(configuration.isPressed ? 0.68 : 1))
            .background(
                RoundedRectangle(cornerRadius: AppDesign.Radius.standard, style: .continuous)
                    .fill(AppDesign.Palette.controlBackground)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AppDesign.Radius.standard, style: .continuous)
                    .strokeBorder(AppDesign.Palette.separator.opacity(0.65), lineWidth: 1)
            }
    }
}
