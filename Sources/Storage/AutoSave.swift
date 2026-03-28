import Foundation

/// Auto-save implementation for documents
///
/// Automatically saves document at intervals while user is typing.
/// Implements debouncing to avoid excessive file writes.
class AutoSave {
    private var saveTimer: Timer?
    private let saveInterval: TimeInterval = 10.0 // Save every 10 seconds
    private let debounceDelay: TimeInterval = 2.0 // Wait 2 seconds after typing

    var onAutoSave: (String) -> Void = { _ in }

    /// Enable auto-save
    /// - Parameter content: Current document content
    func startAutoSave(for content: String) {
        saveTimer?.invalidate()

        // Debounce: wait before saving
        saveTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { [weak self] _ in
            self?.onAutoSave(content)

            // Schedule periodic saves
            self?.saveTimer = Timer.scheduledTimer(
                withTimeInterval: self?.saveInterval ?? 10.0,
                repeats: true
            ) { [weak self] _ in
                self?.onAutoSave(content)
            }
        }
    }

    /// Disable auto-save
    func stopAutoSave() {
        saveTimer?.invalidate()
        saveTimer = nil
    }

    deinit {
        stopAutoSave()
    }
}
