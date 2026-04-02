import Foundation

/// User preference management
///
/// Stores:
/// - Editor preferences (font size, theme)
/// - Compilation settings
/// - Export defaults
/// - Recent templates
class UserPreferences {
    static let shared = UserPreferences()

    private let defaults = UserDefaults.standard

    // MARK: - Editor

    var fontSize: Double {
        get { defaults.double(forKey: "fontSize") > 0 ? defaults.double(forKey: "fontSize") : 14 }
        set { defaults.set(newValue, forKey: "fontSize") }
    }

    var theme: String {
        get { defaults.string(forKey: "theme") ?? "dark" }
        set { defaults.set(newValue, forKey: "theme") }
    }

    var fontFamily: String {
        get { defaults.string(forKey: "fontFamily") ?? "JetBrains Mono" }
        set { defaults.set(newValue, forKey: "fontFamily") }
    }

    // MARK: - Auto-Save

    var autoSaveInterval: Double {
        get { defaults.double(forKey: "autoSaveInterval") > 0 ? defaults.double(forKey: "autoSaveInterval") : 10 }
        set { defaults.set(newValue, forKey: "autoSaveInterval") }
    }

    // MARK: - Cloud

    var iCloudEnabled: Bool {
        get { defaults.bool(forKey: "iCloudEnabled") }
        set { defaults.set(newValue, forKey: "iCloudEnabled") }
    }

    // MARK: - Export

    var exportFormat: String {
        get { defaults.string(forKey: "exportFormat") ?? "pdf" }
        set { defaults.set(newValue, forKey: "exportFormat") }
    }

    var recentTemplates: [String] {
        get { defaults.array(forKey: "recentTemplates") as? [String] ?? [] }
        set { defaults.set(newValue, forKey: "recentTemplates") }
    }

    /// Add template to recent list
    func addRecentTemplate(_ templateId: String) {
        var recent = recentTemplates
        recent.removeAll { $0 == templateId }
        recent.insert(templateId, at: 0)
        recentTemplates = Array(recent.prefix(5)) // Keep last 5
    }
}
