import SwiftUI

/// Template library browser
///
/// Displays all available templates (built-in + custom) with descriptions,
/// search, and categorization.
/// Uses Foundry dark forge aesthetic.
struct TemplateLibrary: View {
    @State private var searchText: String = ""
    @State private var templates: [Template] = []
    @State private var selectedCategory: String = "All"

    let templateManager = TemplateManager.shared

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(DesignSystem.Colors.textMuted)

                TextField("Search templates...", text: $searchText)
                    .textFieldStyle(.plain)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(DesignSystem.Colors.textMuted)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.bgSurface)

            Divider()
                .background(DesignSystem.Colors.borderDefault)

            // Category chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    categoryChip("All")
                    categoryChip("Resume")
                    categoryChip("Academic")
                    categoryChip("Letter")
                    categoryChip("Custom")
                }
                .padding(DesignSystem.Spacing.md)
            }
            .background(DesignSystem.Colors.bgElevated)

            Divider()
                .background(DesignSystem.Colors.borderDefault)

            // Template list
            List(filteredTemplates) { template in
                TemplateRow(
                    template: template,
                    isSelected: false,
                    action: {}
                )
                .listRowBackground(DesignSystem.Colors.bgBase)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .background(DesignSystem.Colors.bgBase)
        .onAppear {
            templates = templateManager.getAvailableTemplates()
        }
        .navigationTitle(ForgeLanguage.templateLibrary)
    }

    // MARK: - Category Chip

    private func categoryChip(_ title: String) -> some View {
        Button(action: { selectedCategory = title }) {
            Text(title)
                .font(DesignSystem.Typography.uiFont(size: 12, weight: selectedCategory == title ? .semibold : .regular))
                .foregroundColor(selectedCategory == title ? DesignSystem.Colors.bgBase : DesignSystem.Colors.textSecondary)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.xs)
                .background(selectedCategory == title ? DesignSystem.Colors.accentAmber : DesignSystem.Colors.bgSurface)
                .cornerRadius(DesignSystem.Radii.small)
        }
        .buttonStyle(.plain)
    }

    var filteredTemplates: [Template] {
        var result = templates

        // Filter by category
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }

        // Filter by search
        if !searchText.isEmpty {
            result = result.filter { template in
                template.name.lowercased().contains(searchText.lowercased()) ||
                template.description.lowercased().contains(searchText.lowercased())
            }
        }

        return result
    }
}

#Preview {
    NavigationView {
        TemplateLibrary()
    }
    .frame(width: 500, height: 400)
}
