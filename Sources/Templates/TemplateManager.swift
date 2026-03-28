import Foundation

/// Manages template library and user-created templates
///
/// Built-in templates:
/// - Resume.typ
/// - Paper.typ
/// - Thesis.typ
/// - Letter.typ
///
/// Users can create custom templates and save to iCloud.
class TemplateManager {
    static let shared = TemplateManager()

    // MARK: - Built-in Templates

    private let builtInTemplates: [Template] = [
        Template(
            id: "resume",
            name: "Resume",
            description: "Professional resume for job applications",
            category: "Resume",
            isBuiltIn: true
        ),
        Template(
            id: "paper",
            name: "Academic Paper",
            description: "Standard academic paper format with sections",
            category: "Academic",
            isBuiltIn: true
        ),
        Template(
            id: "thesis",
            name: "Thesis",
            description: "Comprehensive academic thesis format",
            category: "Academic",
            isBuiltIn: true
        ),
        Template(
            id: "letter",
            name: "Letter",
            description: "Professional business letter format",
            category: "Letter",
            isBuiltIn: true
        )
    ]

    // MARK: - Template Discovery

    /// Get list of available templates
    /// - Returns: Array of template metadata
    func getAvailableTemplates() -> [Template] {
        var templates = builtInTemplates

        // Add user templates from iCloud or local storage
        let userTemplates = loadUserTemplates()
        templates.append(contentsOf: userTemplates)

        return templates
    }

    /// Load template content
    /// - Parameter templateId: Template identifier
    /// - Returns: Template source code
    func loadTemplate(_ templateId: String) -> String? {
        // First, check built-in templates
        if let builtIn = loadBuiltInTemplate(templateId) {
            return builtIn
        }

        // Then check user templates
        return loadUserTemplateContent(templateId)
    }

    // MARK: - Built-in Templates

    private func loadBuiltInTemplate(_ id: String) -> String? {
        // For Swift Package, load from Resources/Templates/
        // The resources should be copied to the bundle

        let templateName: String
        switch id.lowercased() {
        case "resume":
            templateName = "Resume"
        case "paper":
            templateName = "Paper"
        case "thesis":
            templateName = "Thesis"
        case "letter":
            templateName = "Letter"
        default:
            return nil
        }

        // Try to load from bundle resources
        if let bundlePath = Bundle.main.path(forResource: templateName, ofType: "typ", inDirectory: "Templates") {
            do {
                return try String(contentsOfFile: bundlePath, encoding: .utf8)
            } catch {
                Logger.error("Failed to load template from bundle: \(error)")
            }
        }

        // Fallback: try to load from Resources directory (for development)
        let resourcesPath = FileManager.default.currentDirectoryPath
            .appending("/Resources/Templates/\(templateName).typ")

        do {
            return try String(contentsOfFile: resourcesPath, encoding: .utf8)
        } catch {
            Logger.error("Failed to load template from resources: \(error)")
        }

        // Return embedded template content as final fallback
        return getEmbeddedTemplateContent(id)
    }

    /// Embedded template content as fallback
    private func getEmbeddedTemplateContent(_ id: String) -> String? {
        switch id.lowercased() {
        case "resume":
            return """
            // Resume Template - Foundry Press
            #set page(paper: "us-letter", margin: (x: 0.75in, y: 0.5in))
            #set text(font: "Helvetica", size: 11pt)

            #align(center)[
              #text(size: 24pt, weight: "bold")[Your Name]
              #text(size: 10pt)[email@example.com | (555) 123-4567]
            ]

            #heading[Professional Summary]
            Results-driven professional with X years of experience.

            #heading[Experience]
            *Position* — Company, City, State
            - Accomplished significant achievement
            - Led team of X members

            #heading[Education]
            *Degree* — University, Year

            #heading[Skills]
            **Technical:** Skill 1, Skill 2
            """

        case "paper":
            return """
            // Academic Paper Template
            #set page(paper: "us-letter", margin: (x: 1in, y: 1in))
            #set text(font: "Times New Roman", size: 12pt)
            #set par(justify: true)

            #align(center)[
              #text(size: 16pt, weight: "bold")[Your Paper Title]
            ]

            #heading[Abstract]
            This is where your abstract goes.

            #heading[Introduction]
            The introduction sets the context.

            #heading[Methodology]
            Explain your research methods.

            #heading[Results]
            Present your findings.

            #heading[Conclusion]
            Summarize key findings.
            """

        case "thesis":
            return """
            // Thesis Template
            #set page(paper: "us-letter", margin: (x: 1.5in, y: 1in))
            #set text(font: "Times New Roman", size: 12pt)
            #set par(justify: true, leading: 2em)

            #align(center)[
              #text(size: 18pt, weight: "bold")[Your Thesis Title]
              Your Full Name
            ]

            #heading[Abstract]
            Summary of thesis.

            #heading(level: 1)[Chapter 1: Introduction]
            Background and problem statement.

            #heading(level: 1)[Chapter 2: Literature Review]
            Review of prior work.

            #heading(level: 1)[Chapter 3: Methodology]
            Research methods.

            #heading(level: 1)[Chapter 4: Results]
            Findings.

            #heading(level: 1)[Chapter 5: Conclusion]
            Summary.
            """

        case "letter":
            return """
            // Letter Template
            #set page(paper: "us-letter", margin: (x: 1in, y: 1in))
            #set text(font: "Times New Roman", size: 12pt)

            #align(right)[
              Your Name\\
              City, State ZIP\\
              email@example.com
            ]

            Dear Recipient,

            This is the opening paragraph of your letter.

            This is the body with supporting details.

            Sincerely,

            Your Name
            """

        default:
            return nil
        }
    }

    // MARK: - User Templates

    private func loadUserTemplates() -> [Template] {
        var templates: [Template] = []

        // Load from iCloud if available
        if UserPreferences.shared.iCloudEnabled,
           let iCloudURL = FileManager.iCloudContainerURL {
            let templatesURL = iCloudURL.appendingPathComponent("Templates")
            if let files = try? FileManager.default.contentsOfDirectory(at: templatesURL, includingPropertiesForKeys: nil) {
                for file in files where file.pathExtension == "typ" {
                    let name = file.deletingPathExtension().lastPathComponent
                    templates.append(Template(
                        id: "user-\(name)",
                        name: name,
                        description: "Custom template",
                        category: "Custom",
                        isBuiltIn: false
                    ))
                }
            }
        }

        // Also check local documents
        let localTemplatesURL = FileManager.documentsDirectory.appendingPathComponent("Templates")
        if let files = try? FileManager.default.contentsOfDirectory(at: localTemplatesURL, includingPropertiesForKeys: nil) {
            for file in files where file.pathExtension == "typ" {
                let name = file.deletingPathExtension().lastPathComponent
                // Avoid duplicates
                if !templates.contains(where: { $0.id == "user-\(name)" }) {
                    templates.append(Template(
                        id: "local-\(name)",
                        name: name,
                        description: "Local template",
                        category: "Custom",
                        isBuiltIn: false
                    ))
                }
            }
        }

        return templates
    }

    private func loadUserTemplateContent(_ id: String) -> String? {
        // Extract name from ID
        let name: String
        if id.hasPrefix("user-") {
            name = String(id.dropFirst(5))
        } else if id.hasPrefix("local-") {
            name = String(id.dropFirst(6))
        } else {
            return nil
        }

        // Try iCloud first
        if UserPreferences.shared.iCloudEnabled,
           let iCloudURL = FileManager.iCloudContainerURL {
            let fileURL = iCloudURL.appendingPathComponent("Templates/\(name).typ")
            if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                return content
            }
        }

        // Try local
        let localURL = FileManager.documentsDirectory.appendingPathComponent("Templates/\(name).typ")
        if let content = try? String(contentsOf: localURL, encoding: .utf8) {
            return content
        }

        return nil
    }

    // MARK: - Save Custom Template

    /// Create custom template from current document
    /// - Parameters:
    ///   - name: Template name
    ///   - source: Typst source code
    func saveCustomTemplate(name: String, source: String) {
        let sanitized = name.replacingOccurrences(of: " ", with: "-")
                          .replacingOccurrences(of: "/", with: "-")

        var saveURL: URL?

        // Prefer iCloud if enabled
        if UserPreferences.shared.iCloudEnabled,
           let iCloudURL = FileManager.iCloudContainerURL {
            let templatesURL = iCloudURL.appendingPathComponent("Templates")
            try? FileManager.default.createDirectory(at: templatesURL, withIntermediateDirectories: true)
            saveURL = templatesURL.appendingPathComponent("\(sanitized).typ")
        } else {
            let templatesURL = FileManager.documentsDirectory.appendingPathComponent("Templates")
            try? FileManager.default.createDirectory(at: templatesURL, withIntermediateDirectories: true)
            saveURL = templatesURL.appendingPathComponent("\(sanitized).typ")
        }

        if let url = saveURL {
            do {
                try source.write(to: url, atomically: true, encoding: .utf8)
                Logger.info("Saved custom template: \(name)")
            } catch {
                Logger.error("Failed to save template: \(error)")
            }
        }
    }

    /// Delete user template
    /// - Parameter templateId: Template to delete
    func deleteTemplate(_ templateId: String) {
        guard !templateId.hasPrefix("user-") || !templateId.hasPrefix("local-") else {
            Logger.warning("Cannot delete built-in template")
            return
        }

        let name = templateId.hasPrefix("user-") ? String(templateId.dropFirst(5)) : String(templateId.dropFirst(6))

        // Try to delete from iCloud
        if let iCloudURL = FileManager.iCloudContainerURL {
            let url = iCloudURL.appendingPathComponent("Templates/\(name).typ")
                    try? FileManager.default.removeItem(at: url)
        }

        // Also try local
        let localURL = FileManager.documentsDirectory.appendingPathComponent("Templates/\(name).typ")
        try? FileManager.default.removeItem(at: localURL)

        Logger.info("Deleted template: \(name)")
    }
}

struct Template: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let category: String // "Resume", "Academic", "Letter", "Custom"
    let isBuiltIn: Bool

    static func == (lhs: Template, rhs: Template) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
