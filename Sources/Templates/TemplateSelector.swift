import SwiftUI

/// Modal sheet for selecting and previewing templates
///
/// Features:
/// - Category filtering (Resume, Academic, Letter, etc.)
/// - Template preview with description
/// - Create new document from template
/// - Save current document as template
/// - Foundry dark forge aesthetic
struct TemplateSelector: View {
    @State private var selectedCategory: String = "All"
    @State private var templates: [Template] = []
    @State private var selectedTemplate: Template?
    @State private var previewContent: String?
    @Binding var isPresented: Bool
    var onSelect: (String) -> Void

    let templateManager = TemplateManager.shared

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(ForgeLanguage.selectTemplate)
                    .font(DesignSystem.Typography.uiFont(size: 18, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DesignSystem.Colors.textMuted)
                }
                .buttonStyle(.plain)
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.bgSurface)

            Divider()
                .background(DesignSystem.Colors.borderDefault)

            // Category filter
            HStack(spacing: DesignSystem.Spacing.sm) {
                categoryButton("All")
                categoryButton("Resume")
                categoryButton("Academic")
                categoryButton("Letter")
                categoryButton("Custom")
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.bgElevated)

            Divider()
                .background(DesignSystem.Colors.borderDefault)

            // Content
            HSplitView {
                // Template list
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.sm) {
                        ForEach(filteredTemplates) { template in
                            TemplateRow(
                                template: template,
                                isSelected: selectedTemplate?.id == template.id
                            ) {
                                selectedTemplate = template
                                previewContent = templateManager.loadTemplate(template.id)
                            }
                        }
                    }
                    .padding(DesignSystem.Spacing.md)
                }
                .frame(minWidth: 200, maxWidth: 300)

                // Preview
                VStack(spacing: 0) {
                    if let template = selectedTemplate {
                        // Preview header
                        HStack {
                            Text(template.name)
                                .font(DesignSystem.Typography.uiFont(size: 14, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.textPrimary)

                            Spacer()

                            if template.isBuiltIn {
                                Text("Built-in")
                                    .font(DesignSystem.Typography.uiFont(size: 11))
                                    .foregroundColor(DesignSystem.Colors.textMuted)
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    .padding(.vertical, DesignSystem.Spacing.xs)
                                    .background(DesignSystem.Colors.bgOverlay)
                                    .cornerRadius(DesignSystem.Radii.small)
                            }
                        }
                        .padding(DesignSystem.Spacing.md)
                        .background(DesignSystem.Colors.bgElevated)

                        Divider()
                            .background(DesignSystem.Colors.borderDefault)

                        // Preview content
                        ScrollView {
                            if let content = previewContent {
                                Text(content)
                                    .font(DesignSystem.Typography.codeFont(size: 12))
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(DesignSystem.Spacing.md)
                            } else {
                                Text("Unable to load preview")
                                    .foregroundColor(DesignSystem.Colors.textMuted)
                            }
                        }
                    } else {
                        VStack(spacing: DesignSystem.Spacing.md) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 48))
                                .foregroundColor(DesignSystem.Colors.textMuted)

                            Text("Select a template to preview")
                                .foregroundColor(DesignSystem.Colors.textMuted)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(minWidth: 300)
            }

            Divider()
                .background(DesignSystem.Colors.borderDefault)

            // Footer
            HStack {
                if let template = selectedTemplate {
                    Text(template.description)
                        .font(DesignSystem.Typography.uiFont(size: 12))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                } else {
                    Text("\(filteredTemplates.count) templates available")
                        .font(DesignSystem.Typography.uiFont(size: 12))
                        .foregroundColor(DesignSystem.Colors.textMuted)
                }

                Spacer()

                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.bordered)

                Button(ForgeLanguage.useTemplate) {
                    if let template = selectedTemplate {
                        onSelect(template.id)
                        isPresented = false
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedTemplate == nil)
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.bgSurface)
        }
        .frame(width: 700, height: 500)
        .background(DesignSystem.Colors.bgBase)
        .onAppear {
            templates = templateManager.getAvailableTemplates()
            if let first = templates.first {
                selectedTemplate = first
                previewContent = templateManager.loadTemplate(first.id)
            }
        }
    }

    // MARK: - Category Button

    private func categoryButton(_ title: String) -> some View {
        Button(action: { selectedCategory = title }) {
            Text(title)
                .font(DesignSystem.Typography.uiFont(size: 12, weight: selectedCategory == title ? .semibold : .regular))
                .foregroundColor(selectedCategory == title ? DesignSystem.Colors.bgBase : DesignSystem.Colors.textSecondary)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(selectedCategory == title ? DesignSystem.Colors.accentAmber : DesignSystem.Colors.bgSurface)
                .cornerRadius(DesignSystem.Radii.small)
        }
        .buttonStyle(.plain)
    }

    var filteredTemplates: [Template] {
        if selectedCategory == "All" {
            return templates
        }
        return templates.filter { $0.category == selectedCategory }
    }
}

// MARK: - Template Row

struct TemplateRow: View {
    let template: Template
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.md) {
                // Icon
                Image(systemName: template.isBuiltIn ? "doc.text.fill" : "doc.badge.plus")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? DesignSystem.Colors.accentAmber : DesignSystem.Colors.textSecondary)
                    .frame(width: 32)

                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(template.name)
                        .font(DesignSystem.Typography.uiFont(size: 13, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Text(template.category)
                        .font(DesignSystem.Typography.uiFont(size: 11))
                        .foregroundColor(DesignSystem.Colors.textMuted)
                }

                Spacer()
            }
            .padding(DesignSystem.Spacing.sm)
            .background(isSelected ? DesignSystem.Colors.bgElevated : Color.clear)
            .cornerRadius(DesignSystem.Radii.small)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radii.small)
                    .stroke(isSelected ? DesignSystem.Colors.accentAmber : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Template Card (alternative grid view)

struct TemplateCard: View {
    let template: Template
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            // Icon area
            VStack {
                Image(systemName: template.isBuiltIn ? "doc.text.fill" : "doc.badge.plus")
                    .font(.system(size: 32))
                    .foregroundColor(DesignSystem.Colors.accentAmber)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(DesignSystem.Colors.bgElevated)
            .cornerRadius(DesignSystem.Radii.medium)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(template.name)
                    .font(DesignSystem.Typography.uiFont(size: 14, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Text(template.description)
                    .font(DesignSystem.Typography.uiFont(size: 11))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
            }

            Button(action: action) {
                Text(ForgeLanguage.useTemplate)
                    .font(DesignSystem.Typography.uiFont(size: 12, weight: .medium))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
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

#Preview {
    TemplateSelector(isPresented: .constant(true)) { _ in }
}
