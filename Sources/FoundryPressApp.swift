import SwiftUI

/// Main app entry point for foundry-press
///
/// A native macOS editor for Typst documents with live preview.
/// Features:
/// - Split-pane editor with live PDF preview
/// - Syntax highlighting for Typst code
/// - Template library for quick document creation
/// - iCloud sync for documents
/// - Dark forge aesthetic from Foundry design system
@main
struct FoundryPressApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark) // Foundry is dark-only
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            appCommands
        }

        // Settings window
        Settings {
            SettingsView()
                .preferredColorScheme(.dark)
        }
    }

    // MARK: - Menu Commands

    @CommandsBuilder
    private var appCommands: some Commands {
        // File menu
        CommandGroup(replacing: .newItem) {
            Button("New Document") {
                appState.createNewDocument()
            }
            .keyboardShortcut("n", modifiers: .command)

            Button("New from Template...") {
                appState.showTemplateSelector = true
            }
            .keyboardShortcut("n", modifiers: [.command, .shift])

            Divider()

            Button("Open...") {
                appState.showOpenPanel = true
            }
            .keyboardShortcut("o", modifiers: .command)

            Divider()

            Button("Save") {
                appState.saveCurrentDocument()
            }
            .keyboardShortcut("s", modifiers: .command)

            Button("Save As...") {
                appState.showSavePanel = true
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])
        }

        CommandGroup(replacing: .importExport) {
            Button("Export to PDF...") {
                appState.exportToPDF()
            }
            .keyboardShortcut("e", modifiers: .command)
        }

        // Edit menu
        CommandGroup(after: .pasteboard) {
            Button("Find") {
                // TODO: Implement find
            }
            .keyboardShortcut("f", modifiers: .command)

            Button("Find and Replace") {
                // TODO: Implement find and replace
            }
            .keyboardShortcut("f", modifiers: [.command, .option])
        }

        // View menu
        CommandGroup(replacing: .sidebar) {
            Button("Toggle Preview Pane") {
                appState.showPreview.toggle()
            }
            .keyboardShortcut("p", modifiers: [.command, .shift])

            Divider()

            Button("Zoom In") {
                appState.zoomIn()
            }
            .keyboardShortcut("+", modifiers: .command)

            Button("Zoom Out") {
                appState.zoomOut()
            }
            .keyboardShortcut("-", modifiers: .command)

            Button("Actual Size") {
                appState.resetZoom()
            }
            .keyboardShortcut("0", modifiers: .command)
        }

        // Help menu
        CommandGroup(replacing: .help) {
            Button("Foundry Press Documentation") {
                if let url = URL(string: "https://github.com/foundry/press") {
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }
}

// MARK: - App State

/// Global application state
@MainActor
class AppState: ObservableObject {
    @Published var showTemplateSelector = false
    @Published var showOpenPanel = false
    @Published var showSavePanel = false
    @Published var showPreview = true
    @Published var zoomLevel: CGFloat = 1.0

    var editorViewModel: EditorViewModel?

    func setEditorViewModel(_ vm: EditorViewModel) {
        editorViewModel = vm
    }

    func createNewDocument() {
        editorViewModel?.newDocument()
    }

    func saveCurrentDocument() {
        editorViewModel?.saveDocument()
    }

    func exportToPDF() {
        // This will be handled by the editor view
        NotificationCenter.default.post(name: .exportToPDF, object: nil)
    }

    func zoomIn() {
        zoomLevel += 0.1
        NotificationCenter.default.post(name: .zoomIn, object: nil)
    }

    func zoomOut() {
        zoomLevel = max(0.5, zoomLevel - 0.1)
        NotificationCenter.default.post(name: .zoomOut, object: nil)
    }

    func resetZoom() {
        zoomLevel = 1.0
        NotificationCenter.default.post(name: .resetZoom, object: nil)
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let exportToPDF = Notification.Name("exportToPDF")
    static let zoomIn = Notification.Name("zoomIn")
    static let zoomOut = Notification.Name("zoomOut")
    static let resetZoom = Notification.Name("resetZoom")
}

// MARK: - Content View

/// Main content view
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var editorViewModel = EditorViewModel()

    var body: some View {
        EditorView()
            .onAppear {
                appState.setEditorViewModel(editorViewModel)
            }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
