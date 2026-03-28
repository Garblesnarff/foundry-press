import SwiftUI
import PDFKit

/// View model for the Typst editor
///
/// Manages:
/// - Document state (source code, PDF preview)
/// - Compilation lifecycle
/// - Debounced compilation on keystroke
/// - Error handling
@MainActor
class EditorViewModel: ObservableObject {
    // MARK: - Published State

    @Published var document: TypstDocument?
    @Published var sourceCode: String = ""
    @Published var previewPDF: Data?
    @Published var isCompiling: Bool = false
    @Published var compilationError: String?
    @Published var hasUnsavedChanges: Bool = false

    // MARK: - Private State

    private var compilationTask: Task<Void, Never>?
    private let compiler = TypstCompiler()
    private let debounceDelay: TimeInterval = 0.5 // 500ms
    private var lastCompileTime: Date?

    // MARK: - Computed Properties

    var statusText: String {
        if isCompiling {
            return ForgeLanguage.forging
        } else if compilationError != nil {
            return ForgeLanguage.forgeError
        } else if previewPDF != nil {
            return ForgeLanguage.forged
        } else {
            return ForgeLanguage.readyToForge
        }
    }

    // MARK: - Initialization

    init() {
        // Start with empty document
        newDocument()
    }

    // MARK: - Document Actions

    /// Create a new empty document
    func newDocument() {
        document = TypstDocument(id: UUID().uuidString, title: "Untitled", content: "")
        sourceCode = ""
        previewPDF = nil
        compilationError = nil
        hasUnsavedChanges = false
    }

    /// Create a new document from a template
    func newFromTemplate(_ template: Template) {
        guard let content = TemplateManager.shared.loadTemplate(template.id) else {
            Logger.warning("Failed to load template: \(template.id)")
            newDocument()
            return
        }

        document = TypstDocument(id: UUID().uuidString, title: "Untitled", content: content)
        sourceCode = content
        hasUnsavedChanges = false
        compilationError = nil

        // Compile immediately
        Task {
            await compileNow()
        }
    }

    /// Open an existing document
    func openDocument(from url: URL) -> Bool {
        guard let doc = DocumentManager.shared.openDocument(at: url) else {
            Logger.error("Failed to open document: \(url.path)")
            return false
        }

        document = doc
        sourceCode = doc.content
        hasUnsavedChanges = false
        compilationError = nil

        // Compile immediately
        Task {
            await compileNow()
        }

        return true
    }

    /// Save current document
    func saveDocument(to url: URL? = nil) {
        guard var doc = document else { return }

        doc.content = sourceCode
        doc.lastModified = Date()

        if let url = url {
            DocumentManager.shared.saveDocument(doc, to: url)
        } else {
            DocumentManager.shared.saveDocument(doc, toICloud: UserPreferences.shared.iCloudEnabled)
        }

        document = doc
        hasUnsavedChanges = false
        Logger.info("Document saved: \(doc.title)")
    }

    /// Export to PDF
    func exportToPDF(to url: URL) {
        guard let pdfData = previewPDF else {
            Logger.warning("No PDF to export")
            return
        }

        do {
            try pdfData.write(to: url)
            Logger.info("PDF exported to: \(url.path)")
        } catch {
            Logger.error("Failed to export PDF: \(error)")
        }
    }

    // MARK: - Compilation

    /// Trigger debounced compilation
    func sourceCodeChanged() {
        hasUnsavedChanges = true
        compilationError = nil

        // Cancel previous task
        compilationTask?.cancel()

        // Create new debounced task
        compilationTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(debounceDelay * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await compile()
        }
    }

    /// Compile immediately without debounce
    func compileNow() async {
        await compile()
    }

    /// Perform compilation
    private func compile() async {
        guard !sourceCode.isEmpty else {
            previewPDF = nil
            isCompiling = false
            return
        }

        isCompiling = true
        compilationError = nil

        let result = await withCheckedContinuation { continuation in
            compiler.compile(source: sourceCode) { result in
                continuation.resume(returning: result)
            }
        }

        // Update state on main thread
        isCompiling = false
        lastCompileTime = Date()

        switch result {
        case .success(let pdfData):
            previewPDF = pdfData
            compilationError = nil
            Logger.debug("Compilation successful: \(pdfData.count) bytes")

        case .failure(let error):
            previewPDF = nil
            compilationError = error.localizedDescription
            Logger.error("Compilation failed: \(error)")
        }
    }
}
