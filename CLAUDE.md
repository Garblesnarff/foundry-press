# foundry-press: Native Typst Editor

## What This Is
A native macOS Typst editor with live preview. Typst is a modern LaTeX alternative gaining adoption among students, academics, and technical writers. Currently, no native Mac editor exists—foundry-press fills this gap with a polished SwiftUI interface.

## Tech Stack

### Frontend
- **Language**: Swift 5.9 + SwiftUI
- **IDE**: Xcode 15+
- **Target**: macOS 13+ Apple Silicon (M1-M4)
- **Syntax Highlighting**: SwiftUI TextEditor + custom highlighter
- **FFI**: Swift ↔ Rust via C bridge for Typst compiler

### Backend (Typst Engine)
- **Compiler**: Typst (Rust) compiled as static library
- **Integration**: C FFI via generated headers
- **Build**: Cargo for Rust, XCFramework for Swift

## Architecture

```
┌──────────────────────────────────────────────┐
│           macOS Foundry Press App            │
│  ┌────────────────────────────────────────┐  │
│  │   SwiftUI Split-Pane Editor            │  │
│  │  ┌──────────┐       ┌──────────┐      │  │
│  │  │  Editor  │  →    │ Preview  │      │  │
│  │  │  (Typst) │  ←    │  (PDF)   │      │  │
│  │  └──────────┘       └──────────┘      │  │
│  │  [Template] [Export] [Settings]       │  │
│  └──────────────┬────────────────────────┘  │
│                 │                            │
│  ┌──────────────▼────────────────────────┐  │
│  │   Typst Compiler (Rust FFI)           │  │
│  │  ┌──────────────────────────────┐     │  │
│  │  │ typst-lib crate              │     │  │
│  │  │ • Parse & compile .typ files │     │  │
│  │  │ • Generate PDF bytes         │     │  │
│  │  │ • Watch for changes          │     │  │
│  │  └──────────────────────────────┘     │  │
│  └──────────────┬────────────────────────┘  │
│                 │                            │
│  ┌──────────────▼────────────────────────┐  │
│  │   iCloud Document Storage             │  │
│  │   (NSUbiquitousKeyValueStore)         │  │
│  └────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
```

## Design System
Foundry shared design system. See `/Sessions/foundry/_shared/DESIGN_SYSTEM.md`.
- Dark forge aesthetic: charcoal blacks, amber accents
- Monospace fonts: JetBrains Mono for code
- Forge language: "Press it" / "Pressing..." / "Pressed." / "RE-PRESS"

## Critical Implementation Notes

### Typst Compilation
- Typst compiler is a Rust library (`typst` crate on crates.io)
- Compile to static library using `cargo build --release`
- Generate C header with `cbindgen` for Swift interop
- Compilation is fast (~500ms typical)—enable live preview on keystroke delay

### Split-Pane Editor
- Left pane: TextEditor (Typst source code)
- Right pane: PDFKit viewer (live-updated PDF)
- Debounce compilation on keystroke (500ms delay)
- Syntax highlighting: SwiftUI attributedString with regex-based lexer

### iCloud Sync
- Use `NSUbiquitousKeyValueStore` for settings
- Use `UIDocument`/`NSDocument` for file storage (automatic iCloud sync)
- Graceful fallback to local storage if iCloud unavailable

### Templates
- Ship default templates: resume, paper, thesis, letter
- Store in app bundle under `Resources/Templates/`
- Allow users to create custom templates (save to iCloud)

### Performance
- Compile in background thread (GCD)
- Cache compiled PDFs to avoid re-rendering on scroll
- Lazy-load preview PDF (on-demand)

## File Structure

```
Sources/
├── FoundryPressApp.swift      # Main app entry point
├── Editor/
│   ├── EditorView.swift
│   ├── SyntaxHighlighter.swift
│   ├── TypstCompiler.swift    # FFI bridge to Rust
│   └── PreviewPane.swift       # PDFKit viewer
├── Templates/
│   ├── TemplateManager.swift
│   ├── TemplateSelector.swift
│   └── TemplateLibrary.swift
├── Storage/
│   ├── DocumentManager.swift
│   ├── iCloudSync.swift
│   └── AutoSave.swift
├── Settings/
│   ├── SettingsView.swift
│   └── UserPreferences.swift
└── Utilities/
    ├── Logger.swift
    └── Helpers.swift

Resources/
├── Templates/
│   ├── Resume.typ
│   ├── Paper.typ
│   ├── Thesis.typ
│   └── Letter.typ
└── Assets.xcassets

docs/
├── DESIGN_SYSTEM.md
└── ARCHITECTURE.md
```

## Build & Run

```bash
# 1. Build Typst library
cd Sources/typst-bridge
cargo build --release
cbindgen --config cbindgen.toml --crate typst_bridge --output ../TypstBridge.h

# 2. Open Xcode project
open FoundryPress.xcodeproj

# 3. Build & run in Xcode (⌘R)
```

## Legal
- **Typst**: Apache-2.0 (code + default fonts are open)
- **foundry-press**: MIT License
- **Templates**: Original content, MIT License

---

**Status**: Scaffolding phase.
