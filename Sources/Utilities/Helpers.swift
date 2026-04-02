import Foundation

/// General utility helpers
extension String {
    /// Check if string is valid Typst file name
    var isValidTypstFileName: Bool {
        self.lowercased().hasSuffix(".typ")
    }

    /// Extract file name without extension
    var fileNameWithoutExtension: String {
        (self as NSString).deletingPathExtension
    }
}

extension Date {
    /// Human-readable relative time (e.g., "2 hours ago")
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Format as ISO 8601 string
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}

extension FileManager {
    /// Get user's Documents folder
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    /// Get iCloud container URL
    static var iCloudContainerURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)
    }

    /// Check if file exists at path
    func fileExists(at url: URL) -> Bool {
        fileExists(atPath: url.path)
    }

    /// Get file size in bytes
    func fileSize(at url: URL) -> Int64 {
        do {
            let attributes = try attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64 ?? 0
        } catch {
            Logger.error("Failed to get file size: \(error)")
            return 0
        }
    }
}
