import SwiftUI
import PDFKit

/// Split-pane editor view with Typst source on left, PDF preview on right
///
/// Features:
/// - Live compilation on keystroke (with debounce)
/// - Syntax highlighting for Typst code
/// - PDF preview with zoom/pan controls
/// - Template toolbar at top
/// - Foundry dark forge aesthetic
struct EditorView: View {
    @StateObject private var viewModel = EditorViewModel()
    @State private var showTemplateSelector = false
    @State private var showSavePanel = false
    @State private var showExportPanel = false

    // User preferences
    @AppStorage("fontSize") private var fontSize: Double = 14

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            editorToolbar

            // Main content
            HStack(spacing: 0) {
                // Editor pane (left)
                editorPane

                // Divider
                Divider()
                    .background(DesignSystem.Colors.borderDefault)

                // Preview pane (right)
                previewPane
            }
        }
        .background(DesignSystem.Colors.bgBase)
        .sheet(isPresented: $showTemplateSelector) {
            TemplateSelector(isPresented: $showTemplateSelector) { templateId in
                let template = Template(
                    id: templateId,
                    name: templateId.capitalized,
                    description: "",
                    category: "Template",
                    isBuiltIn: true
                )
                viewModel.newFromTemplate(template)
            }
        }
    }

    // MARK: - Toolbar

    private var editorToolbar: some View {
        HStack {
            // Left side - document actions
            HStack(spacing: DesignSystem.Spacing.sm) {
                Button(action: { viewModel.newDocument() }) {
                    Label("New", systemImage: "doc.badge.plus")
                }
                .buttonStyle(.borderless)
                .help("New Document (⌘N)")

                Button(action: { showTemplateSelector = true }) {
                    Label("Template", systemImage: "doc.text.fill")
                }
                .buttonStyle(.borderless)
                .help("New from Template")

                Divider()
                    .frame(height: 16)

                if let document = viewModel.document {
                    Text(document.title)
                        .font(DesignSystem.Typography.uiFont(size: 13, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    if viewModel.hasUnsavedChanges {
                        Text("•")
                            .foregroundColor(DesignSystem.Colors.accentAmber)
                    }
                }
            }

            Spacer()

            // Center - status
            HStack(spacing: DesignSystem.Spacing.xs) {
                if viewModel.isCompiling {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 16, height: 16)

                    Text(ForgeLanguage.forging)
                        .font(DesignSystem.Typography.uiFont(size: 12))
                        .foregroundColor(DesignSystem.Colors.accentAmber)
                } else if let error = viewModel.compilationError {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(DesignSystem.Colors.danger)

                    Text(ForgeLanguage.forgeError)
                        .font(DesignSystem.Typography.uiFont(size: 12))
                        .foregroundColor(DesignSystem.Colors.danger)
                } else if viewModel.previewPDF != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(DesignSystem.Colors.success)

                    Text(ForgeLanguage.forged)
                        .font(DesignSystem.Typography.uiFont(size: 12))
                        .foregroundColor(DesignSystem.Colors.success)
                }
            }

            Spacer()

            // Right side - export and settings
            HStack(spacing: DesignSystem.Spacing.sm) {
                Menu {
                    Button("Save (⌘S)") {
                        saveDocument()
                    }
                    Button("Save As...") {
                        showSavePanel = true
                    }
                    Divider()
                    Button("Export to PDF (⌘E)") {
                        exportToPDF()
                    }
                } label: {
                    Label("File", systemImage: "ellipsis.circle")
                }
                .buttonStyle(.borderless)
                .menuStyle(.borderlessButton)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(DesignSystem.Colors.bgSurface)
    }

    // MARK: - Editor Pane

    private var editorPane: some View {
        VStack(spacing: 0) {
            // Editor header
            HStack {
                Text("SOURCE")
                    .font(DesignSystem.Typography.uiFont(size: 11, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textMuted)
                    .tracking(0.5)

                Spacer()

                Text("\(viewModel.sourceCode.count) chars")
                    .font(DesignSystem.Typography.codeFont(size: 11))
                    .foregroundColor(DesignSystem.Colors.textMuted)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(DesignSystem.Colors.bgElevated)

            // Text editor
            TextEditor(text: $viewModel.sourceCode)
                .font(DesignSystem.Typography.codeFont(size: fontSize))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .background(DesignSystem.Colors.bgBase)
                .onChange(of: viewModel.sourceCode) { _ in
                    viewModel.sourceCodeChanged()
                }
        }
        .frame(minWidth: 300)
    }

    // MARK: - Preview Pane

    private var previewPane: some View {
        VStack(spacing: 0) {
            // Preview header
            HStack {
                Text("PREVIEW")
                    .font(DesignSystem.Typography.uiFont(size: 11, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textMuted)
                    .tracking(0.5)

                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(DesignSystem.Colors.bgElevated)

            // Preview content
            PreviewPane(
                pdfData: viewModel.previewPDF,
                isLoading: viewModel.isCompiling,
                error: viewModel.compilationError
            )
        }
        .frame(minWidth: 300)
    }

    // MARK: - Actions

    private func saveDocument() {
        viewModel.saveDocument()
    }

    private func exportToPDF() {
        guard viewModel.previewPDF != nil else { return }
        let panel = NSSavePanel()
        panel.title = "Export to PDF"
        panel.nameFieldStringValue = viewModel.document?.title ?? "Untitled"
        panel.allowedContentTypes = [.pdf]
        panel.canCreateDirectories = true

        if panel.runModal() == .OK, let url = panel.url {
            viewModel.exportToPDF(to: url)
        }
    }
}

#Preview {
    EditorView()
        .frame(width: 900, height: 600)
}
