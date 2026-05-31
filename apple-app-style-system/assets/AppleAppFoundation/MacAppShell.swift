import SwiftUI

struct MacSplitAppShell<Sidebar: View, Detail: View>: View {
    let title: String
    @ViewBuilder var sidebar: Sidebar
    @ViewBuilder var detail: Detail

    var body: some View {
        NavigationSplitView {
            sidebar
                .navigationSplitViewColumnWidth(
                    min: AppDesign.Metrics.macSidebarIdealWidth - 40,
                    ideal: AppDesign.Metrics.macSidebarIdealWidth
                )
        } detail: {
            detail
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppDesign.Palette.background)
        }
        .navigationTitle(title)
    }
}

struct MacSidebarRow: View {
    let title: String
    var detail: String?
    let systemImage: String
    var isSelected = false

    var body: some View {
        HStack(spacing: AppDesign.Spacing.sm) {
            Image(systemName: systemImage)
                .foregroundStyle(isSelected ? AppDesign.Palette.accent : AppDesign.Palette.secondaryText)
                .frame(width: 16)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .lineLimit(1)

                if let detail, !detail.isEmpty {
                    Text(detail)
                        .font(AppDesign.Typography.metadata)
                        .foregroundStyle(AppDesign.Palette.secondaryText)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: AppDesign.Spacing.xs)
        }
        .accessibilityElement(children: .combine)
    }
}
