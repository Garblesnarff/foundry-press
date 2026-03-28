# Foundry Press — Product Requirements Document

## Problem Statement
Typst is a modern, faster LaTeX alternative gaining adoption in academia and technical communities. However, there is no native, polished macOS editor. Users resort to VS Code, web-based editors, or command-line tools. Foundry Press fills this gap with a beautiful, responsive native editor.

## Target Users
- Students writing theses and papers
- Academics publishing research
- Technical writers
- Anyone who wants a modern LaTeX replacement

## Success Criteria
1. **Live Preview**: Edit Typst on left, see PDF preview on right in real-time (500ms lag acceptable)
2. **Template Library**: Ship with 4 default templates (resume, paper, thesis, letter); allow custom templates
3. **iCloud Sync**: Documents automatically sync across user's Macs
4. **Export**: Clean PDF export with metadata preservation
5. **Syntax Highlighting**: Typst syntax colored appropriately
6. **Performance**: Compile in <1 second for typical documents
7. **Offline**: 100% offline—no cloud compilation required

## Non-Goals
- Multi-user collaboration
- Web version
- AI-powered content generation
- Template marketplace

## Feature Roadmap

### MVP (Phase 1)
- [x] Split-pane editor + PDF preview
- [x] Syntax highlighting
- [x] 4 built-in templates
- [x] Save/open documents
- [x] PDF export
- [ ] iCloud sync (Phase 2)

### Phase 2
- [ ] Custom template creation
- [ ] Find & replace
- [ ] Code snippets
- [ ] Document outline (navigation)

### Phase 3
- [ ] Project-level templates
- [ ] Bibliography management (Typst native)
- [ ] Math equation assistant

## Pricing
- Freemium: Basic editor, 4 templates
- Pro: Custom templates, priority support (if applicable)

## Marketing Angle
"Typst made beautiful. No command line, no VS Code. Just press your text."

---

Specification version 1.0. Last updated 2026-03-15.
