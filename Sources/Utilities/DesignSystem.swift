import SwiftUI

/// Foundry Press Design System
///
/// Dark forge aesthetic: charcoal blacks, amber accents
/// Typography: DM Sans (UI), JetBrains Mono (editor code)
/// Forge language: "Press it" / "Pressing..." / "Pressed." / "RE-PRESS"
enum DesignSystem {
    // MARK: - Colors

    enum Colors {
        /// Backgrounds
        static let bgBase = Color(hex: "#141210")
        static let bgSurface = Color(hex: "#1A1816")
        static let bgElevated = Color(hex: "#201E1A")
        static let bgOverlay = Color(hex: "#2A2622")

        /// Borders
        static let borderDefault = Color(hex: "#3A352E")
        static let borderHover = Color(hex: "#4A4438")

        /// Text
        static let textPrimary = Color(hex: "#E8E0D4")
        static let textSecondary = Color(hex: "#B8AFA4")
        static let textMuted = Color(hex: "#8A8278")

        /// Accent
        static let accentAmber = Color(hex: "#E8A849")
        static let accentAmberHover = Color(hex: "#F0B85A")

        /// Status
        static let danger = Color(hex: "#E85A5A")
        static let success = Color(hex: "#5AE88A")

        /// Syntax Highlighting (Typst)
        enum Syntax {
            static let keyword = Color(hex: "#E8A849")       // Amber for #let, #set, etc.
            static let string = Color(hex: "#5AE88A")        // Green for strings
            static let comment = Color(hex: "#8A8278")       // Muted gray for comments
            static let number = Color(hex: "#E85A5A")        // Red for numbers
            static let `operator` = Color(hex: "#B8AFA4")    // Secondary for operators
            static let markup = Color(hex: "#E8E0D4")        // Primary for markup
            static let function = Color(hex: "#F0B85A")      // Amber hover for function calls
        }
    }

    // MARK: - Typography

    enum Typography {
        /// Font for UI text (labels, buttons, etc.)
        static func uiFont(size: CGFloat = 14, weight: Font.Weight = .regular) -> Font {
            .system(size: size, weight: weight, design: .default)
        }

        /// Font for code editing (Typst source)
        static func codeFont(size: CGFloat = 14) -> Font {
            .system(size: size, design: .monospaced)
        }

        /// Font for app titles
        static func titleFont(size: CGFloat = 24) -> Font {
            .system(size: size, weight: .bold, design: .serif)
        }
    }

    // MARK: - Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    // MARK: - Radii

    enum Radii {
        static let small: CGFloat = 6
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let circular: CGFloat = .infinity
    }

    // MARK: - Animation

    enum Animation {
        static let fadeIn = SwiftUI.Animation.easeOut(duration: 0.3)
        static let glow = SwiftUI.Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)
        static let pulse = SwiftUI.Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Forge Language

/// Forge-specific UI strings
enum ForgeLanguage {
    // Actions
    static let press = "Press it"
    static let pressing = "Pressing..."
    static let pressed = "Pressed."
    static let repress = "RE-PRESS"

    // Compilation
    static let forging = "Forging..."
    static let forged = "Forged."
    static let forgeError = "Forge Error"

    // Documents
    static let newDocument = "New Document"
    static let openDocument = "Open Document"
    static let saveDocument = "Save Document"
    static let export = "Export"

    // Status
    static let noPreview = "No Preview"
    static let startTyping = "Start typing to forge..."
    static let compilationError = "Forge Error"
    static let readyToForge = "Ready to forge"

    // Templates
    static let selectTemplate = "Select Template"
    static let useTemplate = "Press Template"
    static let templateLibrary = "Template Library"

    // Empty states
    static let noDocuments = "No Documents Yet"
    static let noDocumentsHint = "Press ⌘N to forge a new document"
    static let noTemplates = "No Templates Found"
}
