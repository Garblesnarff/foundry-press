import Foundation
import UniformTypeIdentifiers

/// Manages document lifecycle (new, open, save, recent)
///
/// Handles:
/// - Creating new documents
/// - Opening existing .typ files
/// - Saving to local or iCloud storage
/// - Recent documents list
class DocumentManager: NSObject {
    static let shared = DocumentManager()

    private let recentDocumentsKey = "recentDocuments"
    private let maxRecentDocuments = 10

    // MARK: - Document Actions

    /// Create new document (optionally from template)
    /// - Parameter templateId: Optional template to use
    /// - Returns: Document with initial content
    func newDocument(fromTemplate templateId: String? = nil) -> TypstDocument {
        var content = ""

        if let templateId = templateId,
           let templateContent = TemplateManager.shared.loadTemplate(templateId) {
            content = templateContent
        }

        return TypstDocument(
            id: UUID().uuidString,
            title: "Untitled",
            content: content,
            fileURL: nil
        )
    }

    /// Open existing document
    /// - Parameter url: File URL to .typ file
    /// - Returns: Document with loaded content
    func openDocument(at url: URL) -> TypstDocument? {
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let title = url.deletingPathExtension().lastPathComponent

            let document = TypstDocument(
                id: UUID().uuidString,
                title: title,
                content: content,
                fileURL: url
            )

            addToRecentDocuments(url)
            Logger.info("Opened document: \(title)")

            return document
        } catch {
            Logger.error("Failed to open document: \(error)")
            return nil
        }
    }

    /// Save document
    /// - Parameters:
    ///   - document: Document to save
    ///   - url: Optional file URL (uses document's URL if not provided)
    func saveDocument(_ document: TypstDocument, to url: URL? = nil) {
        let targetURL = url ?? document.fileURL ?? defaultSaveURL(for: document.title)

        do {
            try document.content.write(to: targetURL, atomically: true, encoding: .utf8)
            addToRecentDocuments(targetURL)
            Logger.info("Saved document: \(document.title)")
        } catch {
            Logger.error("Failed to save document: \(error)")
        }
    }

    /// Save document to iCloud or local storage
    func saveDocument(_ document: TypstDocument, toICloud: Bool) {
        if toICloud {
            if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?
                .appendingPathComponent("Documents")
                .appendingPathComponent("\(document.title).typ") {

                // Ensure iCloud Documents directory exists
                try? FileManager.default.createDirectory(at: iCloudURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                saveDocument(document, to: iCloudURL)
                return
            }
        }

        // Fallback to local
        saveDocument(document, to: nil)
    }

    /// Get recent documents
    /// - Returns: List of recently opened documents (as URLs)
    func getRecentDocuments() -> [URL] {
        let defaults = UserDefaults.standard
        guard let paths = defaults.array(forKey: recentDocumentsKey) as? [String] else {
            return []
        }

        return paths.compactMap { URL(fileURLWithPath: $0) }
    }

    /// Delete document
    /// - Parameter url: Document URL to delete
    func deleteDocument(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            removeFromRecentDocuments(url)
            Logger.info("Deleted document: \(url.lastPathComponent)")
        } catch {
            Logger.error("Failed to delete document: \(error)")
        }
    }

    // MARK: - Private Helpers

    private func defaultSaveURL(for title: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(title).typ")
    }

    private func addToRecentDocuments(_ url: URL) {
        var recent = getRecentDocuments().map { $0.path }

        // Remove if already exists
        recent.removeAll { $0 == url.path }

        // Add to front
        recent.insert(url.path, at: 0)

        // Limit size
        if recent.count > maxRecentDocuments {
            recent = Array(recent.prefix(maxRecentDocuments))
        }

        UserDefaults.standard.set(recent, forKey: recentDocumentsKey)
    }

    private func removeFromRecentDocuments(_ url: URL) {
        var recent = getRecentDocuments().map { $0.path }
        recent.removeAll { $0 == url.path }
        UserDefaults.standard.set(recent, forKey: recentDocumentsKey)
    }
}

struct TypstDocument: Identifiable {
    let id: String
    var title: String
    var content: String
    var lastModified: Date = Date()
    var fileURL: URL?
    var isSaved: Bool = true
}
