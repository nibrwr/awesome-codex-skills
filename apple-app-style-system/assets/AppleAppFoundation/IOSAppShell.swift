import SwiftUI

struct IOSStackAppShell<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppDesign.Spacing.md) {
                    content
                }
                .padding(AppDesign.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(AppDesign.Palette.background)
            .navigationTitle(title)
        }
        .tint(AppDesign.Palette.accent)
    }
}

struct IOSTouchRow<Accessory: View>: View {
    let title: String
    var subtitle: String?
    var systemImage: String?
    @ViewBuilder var accessory: Accessory

    var body: some View {
        HStack(spacing: AppDesign.Spacing.sm) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(AppDesign.Palette.accent)
                    .frame(width: 24)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: AppDesign.Spacing.xxs) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppDesign.Palette.primaryText)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppDesign.Typography.detail)
                        .foregroundStyle(AppDesign.Palette.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: AppDesign.Spacing.sm)
            accessory
        }
        .frame(minHeight: AppDesign.Metrics.touchTarget)
        .padding(AppDesign.Spacing.md)
        .appSurface(.standard)
        .accessibilityElement(children: .combine)
    }
}
