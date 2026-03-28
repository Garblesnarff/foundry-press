# foundry-press Design System

See the shared Foundry design system for complete specifications:

**Location**: `/Sessions/foundry/_shared/DESIGN_SYSTEM.md`

## App-Specific Adaptations

### Forge Language (for foundry-press)

- **Verb (Base)**: "Press"
- **Gerund (Action)**: "Pressing..."
- **Past (Complete)**: "Pressed."
- **Reset**: "RE-PRESS"

Example usage in UI:
- Save button: "Press to save"
- Compilation state: "Pressing..." (while compiling)
- Completion message: "Pressed. Document ready."
- Restart compilation: "RE-PRESS document"

### Editor Aesthetic

**Split-Pane Layout**:
- Left pane: Code editor (monospace, syntax highlighting)
- Divider: Vertical amber line with drag handle
- Right pane: PDF preview (PDFKit viewer)
- Responsive: On narrow screens, stacked vertically

**Code Editor**:
- Font: JetBrains Mono, 14pt (default, user-adjustable 10-24pt)
- Background: `--bg-base` (#141210)
- Text: `--text-primary` (#E8E0D4)
- Line numbers: `--text-muted` (#8A8278)
- Cursor: Amber accent color

**Syntax Highlighting**:
- Keywords (#let, #set, #show): `--accent-amber`
- Strings ("..."): `--success` green
- Comments (//): `--text-muted` gray
- Markup (=, ==, ===, -, +): `--accent-amber`
- Numbers: `--text-secondary`

**PDF Preview Pane**:
- White background for document visibility
- Toolbar top-right: Zoom in/out, fit-to-width buttons
- Page indicators: Current page / total pages
- Smooth scroll with momentum

### Template Selector UI

**Template Cards**:
- 2-column grid (desktop), 1-column (mobile)
- Background: `--bg-surface` (#1A1816)
- Border: 1px solid `--border-default`
- Icon area: `--bg-elevated` (#201E1A) with blue doc icon
- Hover: Subtle glow, border becomes `--accent-amber`
- Selected: Checkmark overlay, amber border

**Category Filter**:
- Segmented control: All, Resume, Academic, Letter, Custom
- Active segment: `--accent-amber` background
- Inactive: `--bg-surface` background

### Settings Panel

**Sections**:
1. Editor (Font size slider)
2. Auto-Save (Interval slider)
3. Cloud (iCloud toggle)
4. Export (Format picker)

**Controls**:
- Sliders: Dark track, amber thumb (from shared system)
- Toggles: Apple system style (light/dark adaptive)
- Pickers: SegmentedPickerStyle or menuStyle

### Toolbar & Menu

**Main Toolbar**:
- New Document (⌘N)
- Open (⌘O)
- Save (⌘S)
- Export PDF (⌘E)
- Settings (⌘,)

**Menu Items**:
- File > New from Template
- File > Recent Documents
- Edit > Find in Document (⌘F)
- Help > Template Library

### Loading State

**Compilation Indicator**:
- Small spinner in PDF pane header while compiling
- Text: "Pressing..." (using forge language)
- Duration: Typically 100-500ms (not obtrusive)

**Error State**:
- Error message in red in PDF pane
- Error box with monospace error details
- Button to clear and retry

### Typography Usage

- **DM Sans (UI)**
  - Document title in toolbar
  - Button labels (Save, Export, Settings)
  - Settings section headers
  - Template names and descriptions

- **JetBrains Mono (Editor)**
  - All source code in editor pane
  - Error messages (diagnostic output)
  - Line numbers
  - Any technical values (compile time, file size)

- **Playfair Display (Headings)**
  - "foundry-press" app title (main window title only)
  - Never in editor or settings
  - Never for document titles

### Color Palette Usage

Primary colors from shared system:

- **Background**: `--bg-base` (#141210) for editor pane
- **Surface**: `--bg-surface` (#1A1816) for cards and panels
- **Elevated**: `--bg-elevated` (#201E1A) for dropdowns and modals
- **Accent**: `--accent-amber` (#E8A849) for highlights, buttons, syntax keywords
- **Text**: `--text-primary` (#E8E0D4) for main code and UI text
- **Muted**: `--text-muted` (#8A8278) for line numbers, comments, secondary labels

**Special Cases**:
- Success (compiled): `--success` (#5AE88A) - subtle glow in status bar
- Error: `--danger` (#E85A5A) - error messages and warning badges
- Preview PDF: White background (for document contrast)

See shared DESIGN_SYSTEM.md for complete color definitions and component specifications.
