# Foundry Press

Native macOS Typst editor with live preview split-pane.

## Quick Start

### Prerequisites
- Xcode 15+ with macOS 13+ SDK
- Rust 1.70+
- Apple Silicon Mac (M1-M4)

### Build

```bash
# Build Typst compiler
cd Sources/typst-bridge
cargo build --release

# Generate FFI header
cbindgen --config cbindgen.toml --crate typst_bridge --output ../TypstBridge.h

# Open and build in Xcode
cd ../..
open FoundryPress.xcodeproj
# Press ⌘R to build and run
```

### Features
- Live preview (left = editor, right = PDF preview)
- Syntax highlighting for Typst syntax
- Built-in templates: resume, paper, thesis, letter
- iCloud document sync
- Export to PDF

## Development

All development follows Foundry conventions. See [AGENTS.md](AGENTS.md) for coordination rules.

### Key Files
- `Sources/FoundryPressApp.swift` — App entry point
- `Sources/Editor/TypstCompiler.swift` — Rust FFI bridge
- `Sources/Templates/TemplateManager.swift` — Template system

### Testing
```bash
# Run in Xcode with ⌘U (Unit Tests)
# Manual testing: Edit templates, preview in split pane
```

## License
Apache-2.0 (Typst), MIT (foundry-press)

---

See [CLAUDE.md](CLAUDE.md) for technical architecture.
