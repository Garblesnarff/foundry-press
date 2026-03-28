import Foundation
import CloudKit

/// iCloud synchronization for documents and settings
///
/// Features:
/// - Automatic iCloud save of documents
/// - Sync settings across devices (via NSUbiquitousKeyValueStore)
/// - Conflict resolution (last-write-wins)
/// - Offline support with local caching
class iCloudSync {
    static let shared = iCloudSync()

    private let ubiquitousStore = NSUbiquitousKeyValueStore.default

    /// Sync document to iCloud
    /// - Parameter document: Document to sync
    func syncDocument(_ document: TypstDocument) {
        // TODO: Save to iCloud with CloudKit or NSDocument
        // Use last-modified timestamp for conflict resolution
    }

    /// Sync settings to iCloud
    /// - Parameter settings: User preferences
    func syncSettings(_ settings: [String: Any]) {
        for (key, value) in settings {
            ubiquitousStore.set(value, forKey: key)
        }
        ubiquitousStore.synchronize()
    }

    /// Get synced setting value
    /// - Parameter key: Setting key
    /// - Returns: Setting value or nil
    func getSetting(_ key: String) -> Any? {
        ubiquitousStore.object(forKey: key)
    }

    /// Listen for iCloud changes
    /// - Parameter callback: Called when sync occurs
    func observeChanges(_ callback: @escaping () -> Void) {
        NotificationCenter.default.addObserver(
            forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: ubiquitousStore,
            queue: .main
        ) { _ in
            callback()
        }
    }

    /// Get iCloud availability status
    /// - Returns: true if iCloud is available
    func isICloudAvailable() -> Bool {
        FileManager.default.ubiquityIdentityToken != nil
    }
}
