# Foundry Press — Task Tracking

## Phase 1: MVP (Split-Pane Editor + Typst Compilation)

### Core Infrastructure
- [x] Set up Xcode project with SwiftUI
- [ ] Integrate Typst Rust crate as static library
- [ ] Create C FFI header (cbindgen)
- [x] Implement TypstCompiler wrapper (Swift bridge) - Mock implementation for now
- [x] Test basic compilation (hello-world.typ → PDF) - Mock compilation works

### Editor View
- [x] Build TextEditor pane (left side)
- [x] Implement syntax highlighting lexer
- [ ] Add auto-indentation for code blocks
- [x] Debounce keystroke compilation (500ms)
- [x] Show compilation errors in UI

### Preview Pane
- [x] Build PDFKit viewer pane (right side)
- [x] Load compiled PDF from in-memory buffer
- [x] Auto-update on compilation complete
- [x] Support zoom in/out
- [ ] Handle large documents (pagination)

### File Management
- [x] Implement file open dialog
- [x] Implement file save dialog
- [x] Add recent files list
- [x] Implement auto-save (every 30 seconds)

### Templates
- [x] Create 4 default templates (resume, paper, thesis, letter)
- [x] Implement template selector dialog
- [x] New document from template action
- [x] Store templates in app bundle

### Export
- [x] Implement PDF export action
- [ ] Add export options (compression, metadata)
- [ ] Test PDF quality on sample documents

### Design System
- [x] Implement Foundry dark forge aesthetic
- [x] Forge language throughout UI
- [x] Menu bar integration
- [x] Keyboard shortcuts

## Phase 2: Enhanced Features

- [ ] iCloud document sync via UIDocument (framework in place)
- [ ] Find & replace functionality
- [ ] Code snippet library
- [ ] Document outline/navigation sidebar
- [x] Preferences panel (font size, theme)

## Phase 3: Polish

- [ ] Performance profiling (< 1s compile time)
- [x] Dark mode support (dark-only as per Foundry design)
- [ ] Accessibility (VoiceOver testing)
- [ ] Unit tests for compiler bridge
- [ ] Integration tests (edit → compile → preview)

## QA & Testing
- [ ] Manual testing on sample documents
- [ ] Test with large documents (50+ pages)
- [ ] Test error handling (syntax errors, file not found)
- [ ] Test on Apple Silicon hardware

## Deployment
- [ ] Create GitHub repository
- [ ] Document build process
- [ ] Prepare for App Store submission
- [ ] Write marketing copy

---

**Priorities**: Infrastructure → Editor → Preview → Export → Templates → Polish

**Status**: Phase 1 MVP largely complete with mock compiler. Real Typst integration pending.
