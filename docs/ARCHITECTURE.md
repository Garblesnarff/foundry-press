# foundry-press Architecture

## Overview

foundry-press is a native macOS editor for Typst documents (a modern LaTeX alternative) featuring live PDF preview, template library, and iCloud sync. The app bridges SwiftUI frontend with a Rust-based Typst compiler via C FFI.

The architecture separates:
- **UI Layer**: SwiftUI for editing, preview, and settings
- **Compiler Layer**: Typst (Rust) via C FFI
- **Storage Layer**: File system + iCloud sync

## Directory Structure

```
Sources/
├── FoundryPressApp.swift            # Main app entry point
├── Editor/
│   ├── EditorView.swift             # Main split-pane editor
│   ├── SyntaxHighlighter.swift      # Regex-based code highlighting
│   ├── TypstCompiler.swift          # FFI bridge to Rust compiler
│   └── PreviewPane.swift            # PDFKit PDF viewer
├── Templates/
│   ├── TemplateManager.swift        # Template CRUD & discovery
│   ├── TemplateSelector.swift       # Template picker UI
│   └── TemplateLibrary.swift        # Template browser
├── Storage/
│   ├── DocumentManager.swift        # Document lifecycle
│   ├── iCloudSync.swift             # iCloud sync manager
│   └── AutoSave.swift               # Debounced auto-save
├── Settings/
│   ├── SettingsView.swift           # Preferences UI
│   └── UserPreferences.swift        # Settings storage
└── Utilities/
    ├── Logger.swift                 # Logging utility
    └── Helpers.swift                # Extension helpers
```

## Component Details

### UI Layer (SwiftUI)

**EditorView**: Main view with split panes:
- Left: TextEditor with Typst source code
- Right: PDF preview using PDFKit
- Debounced compilation on keystroke (500ms default)
- Status bar showing compilation state

**SyntaxHighlighter**: Regex-based lexer for Typst code:
- Keywords: #let, #set, #show, #import, etc.
- Strings and comments
- Markup: =, ==, ===, -, +, * for heading/bullet
- Returns AttributedString with color annotations

**PreviewPane**: PDFKit viewer for compiled output:
- Displays PDF from TypstCompiler
- Zoom in/out controls
- Fit-to-width button
- Search functionality
- Lazy-loads PDF on demand

**TemplateSelector**: Modal for choosing document template:
- Grid view of built-in + custom templates
- Category filter (Resume, Academic, Letter, Custom)
- Card preview with description
- One-click "Use Template" button

**SettingsView**: User preferences:
- Font size slider (10-24pt)
- Theme selection (dark/light/system)
- Auto-save interval (5-60 seconds)
- iCloud sync toggle
- Export format (PDF/PNG)

### Compiler Layer (C FFI)

**TypstCompiler**: Bridge to Typst Rust library:
- Runs compilation on background DispatchQueue (QoS: userInitiated)
- Calls C FFI function `typst_compile(source: CString) -> PDF`
- Returns PDF bytes or error string
- Caches compiled PDFs to avoid re-rendering on scroll

**Process**:
1. Editor calls `compile(source:completion:)` on keystroke
2. TypstCompiler enqueues to background queue
3. C FFI calls `typst_compile()` in Rust
4. Returns PDF data or error message
5. Main thread updates PreviewPane
6. User sees live preview (typically <500ms)

**Performance**:
- Typical compile time: ~100-500ms
- Debounce delay: 500ms after keystroke
- Cached PDFs reduce re-render overhead

### Storage Layer

**DocumentManager**: Document lifecycle:
- `newDocument()`: Create blank or from template
- `openDocument(at:)`: Load from file system or iCloud
- `saveDocument(_:toICloud:)`: Write to storage
- `getRecentDocuments()`: List recently opened files
- `exportToPDF(_:to:)`: Compile and save to PDF

**AutoSave**: Debounced periodic saving:
- Waits 2 seconds after last keystroke
- Saves every 10 seconds while user is typing
- Prevents excessive file writes
- Uses Timer with invalidation on stop

**iCloudSync**: Cloud synchronization:
- `NSUbiquitousKeyValueStore` for settings (font size, theme, etc.)
- CloudKit or NSDocument for document storage
- Last-write-wins conflict resolution
- Observes `didChangeExternallyNotification` for remote changes
- `isICloudAvailable()` checks iCloud status

### Settings & Preferences

**UserPreferences**: Single-source-of-truth for settings:
- Stores in `UserDefaults` + iCloud sync
- Font size, theme, font family
- Auto-save interval, iCloud toggle
- Export format
- Recent templates list (keeps last 5)

**Properties**:
- `fontSize`: Default 14pt
- `theme`: dark/light/system
- `fontFamily`: JetBrains Mono
- `autoSaveInterval`: Default 10 seconds
- `iCloudEnabled`: Default true
- `exportFormat`: Default PDF

## Data Flow

### New Document
1. User selects "New" from menu
2. DocumentManager creates TypstDocument with empty content
3. EditorView displays editor + empty preview
4. AutoSave begins monitoring (no save until first change)

### From Template
1. User selects "New from Template"
2. TemplateSelector modal opens
3. User picks template (e.g., Resume.typ)
4. TemplateManager loads template content from bundle/iCloud
5. DocumentManager creates new document with template content
6. EditorView displays template code
7. TypstCompiler auto-compiles template
8. User sees PDF preview and begins editing

### Save & Sync
1. User edits document (EditorView TextEditor)
2. AutoSave debounce timer resets
3. After keystroke + 2 seconds (debounce), AutoSave fires
4. DocumentManager.saveDocument() called
5. File written to iCloud (if enabled) or local storage
6. iCloudSync syncs metadata to NSUbiquitousKeyValueStore

### Live Compilation
1. User types character in EditorView
2. TextEditor updates @State sourceCode
3. onChange modifier triggers debounceCompilation()
4. Timer waits 500ms for typing to stop
5. TypstCompiler.compile(source:completion:) called
6. Background DispatchQueue executes C FFI
7. Typst Rust lib compiles source to PDF
8. PDF bytes returned to main queue
9. PreviewPane updates via @State previewPDF
10. User sees live PDF preview

## Performance Considerations

- **Compilation**: Rust library compiled as static library for fast execution
- **Threading**: All compilation on background queue (doesn't freeze UI)
- **Debouncing**: 500ms delay prevents excessive compilation on rapid typing
- **Caching**: Compiled PDFs cached in memory to avoid re-renders during scroll
- **Storage**: iCloud automatically syncs; fallback to local if unavailable
- **Font Loading**: Typst includes default fonts (no dynamic font loading needed)

## Design System Integration

Uses Foundry shared design system: `/Sessions/foundry/_shared/DESIGN_SYSTEM.md`

- **Colors**: Dark forge aesthetic (charcoal/amber)
- **Typography**: DM Sans (UI), JetBrains Mono (editor code)
- **Animations**: Fade transitions on pane reveal, subtle pulse on compiling
- **Forge language**: "Press it" / "Pressing..." / "Pressed." / "RE-PRESS"

## Legal & Attribution

- **Typst**: Apache-2.0 (open source, free to use)
- **foundry-press**: MIT License
- **Templates**: Original content, MIT License
- **Default Fonts**: Included with Typst (free)

See CLAUDE.md for implementation roadmap.
