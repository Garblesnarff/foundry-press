import SwiftUI

/// App settings and preferences
///
/// Options for:
/// - Font size
/// - Theme (dark only for Foundry)
/// - Auto-save interval
/// - iCloud sync toggle
/// - Export preferences
/// Uses Foundry dark forge aesthetic.
struct SettingsView: View {
    @AppStorage("fontSize") var fontSize: Double = 14
    @AppStorage("autoSaveInterval") var autoSaveInterval: Double = 10
    @AppStorage("iCloudEnabled") var iCloudEnabled: Bool = true
    @AppStorage("exportFormat") var exportFormat: String = "pdf"

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(DesignSystem.Typography.uiFont(size: 18, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.bgSurface)

            Divider()
                .background(DesignSystem.Colors.borderDefault)

            ScrollView {
                VStack(spacing: DesignSystem.Spacing.lg) {
                    // Editor Settings
                    settingsSection(title: "Editor") {
                        fontSizeSlider
                    }

                    // Auto-Save Settings
                    settingsSection(title: "Auto-Save") {
                        autoSaveSlider
                    }

                    // Cloud Settings
                    settingsSection(title: "Cloud") {
                        iCloudToggle
                    }

                    // Export Settings
                    settingsSection(title: "Export") {
                        exportFormatPicker
                    }
                }
                .padding(DesignSystem.Spacing.md)
            }
        }
        .background(DesignSystem.Colors.bgBase)
    }

    // MARK: - Settings Sections

    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(title.uppercased())
                .font(DesignSystem.Typography.uiFont(size: 11, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.textMuted)
                .tracking(0.5)

            VStack(spacing: DesignSystem.Spacing.md) {
                content()
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.bgSurface)
            .cornerRadius(DesignSystem.Radii.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radii.medium)
                    .stroke(DesignSystem.Colors.borderDefault, lineWidth: 1)
            )
        }
    }

    // MARK: - Editor Settings

    private var fontSizeSlider: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text("Font Size")
                    .font(DesignSystem.Typography.uiFont(size: 13))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                Text("\(Int(fontSize))pt")
                    .font(DesignSystem.Typography.codeFont(size: 13))
                    .foregroundColor(DesignSystem.Colors.accentAmber)
            }

            Slider(value: $fontSize, in: 10...24, step: 1)
                .tint(DesignSystem.Colors.accentAmber)
        }
    }

    // MARK: - Auto-Save Settings

    private var autoSaveSlider: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Text("Save Interval")
                    .font(DesignSystem.Typography.uiFont(size: 13))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                Text("\(Int(autoSaveInterval))s")
                    .font(DesignSystem.Typography.codeFont(size: 13))
                    .foregroundColor(DesignSystem.Colors.accentAmber)
            }

            Slider(value: $autoSaveInterval, in: 5...60, step: 5)
                .tint(DesignSystem.Colors.accentAmber)

            Text("Documents auto-save after this many seconds of inactivity")
                .font(DesignSystem.Typography.uiFont(size: 11))
                .foregroundColor(DesignSystem.Colors.textMuted)
        }
    }

    // MARK: - Cloud Settings

    private var iCloudToggle: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("iCloud Sync")
                        .font(DesignSystem.Typography.uiFont(size: 13))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Text("Sync documents across your Macs")
                        .font(DesignSystem.Typography.uiFont(size: 11))
                        .foregroundColor(DesignSystem.Colors.textMuted)
                }

                Spacer()

                Toggle("", isOn: $iCloudEnabled)
                    .toggleStyle(.switch)
                    .tint(DesignSystem.Colors.accentAmber)
            }
        }
    }

    // MARK: - Export Settings

    private var exportFormatPicker: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("Default Export Format")
                .font(DesignSystem.Typography.uiFont(size: 13))
                .foregroundColor(DesignSystem.Colors.textPrimary)

            HStack(spacing: DesignSystem.Spacing.sm) {
                formatButton("PDF", value: "pdf")
                formatButton("PNG", value: "png")
            }
        }
    }

    private func formatButton(_ title: String, value: String) -> some View {
        Button(action: { exportFormat = value }) {
            Text(title)
                .font(DesignSystem.Typography.uiFont(size: 12, weight: exportFormat == value ? .semibold : .regular))
                .foregroundColor(exportFormat == value ? DesignSystem.Colors.bgBase : DesignSystem.Colors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(exportFormat == value ? DesignSystem.Colors.accentAmber : DesignSystem.Colors.bgElevated)
                .cornerRadius(DesignSystem.Radii.small)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
        .frame(width: 400, height: 500)
}
