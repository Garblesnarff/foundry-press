import SwiftUI

/// Syntax highlighter for Typst code
///
/// Provides regex-based lexing for:
/// - Keywords (#let, #set, #show, etc.)
/// - Strings and comments
/// - Numbers and operators
/// - Markup (= heading, - bullet, etc.)
class SyntaxHighlighter {
    // MARK: - Token Types

    private enum TokenType {
        case keyword
        case string
        case comment
        case number
        case heading
        case bullet
        case function
        case operator_
        case bracket
    }

    // MARK: - Patterns

    private let patterns: [(NSRegularExpression, TokenType)] = {
        var result: [(NSRegularExpression, TokenType)] = []

        // Keywords: #let, #set, #show, #import, #include, #if, #else, #for, #while, #return, #break, #continue
        if let regex = try? NSRegularExpression(pattern: "#(let|set|show|import|include|if|else|for|while|return|break|continue|func|assert)\\b", options: []) {
            result.append((regex, .keyword))
        }

        // Strings: "..." and content blocks [...]
        if let regex = try? NSRegularExpression(pattern: "\"([^\"\\\\]|\\\\.)*\"", options: []) {
            result.append((regex, .string))
        }

        // Comments: //
        if let regex = try? NSRegularExpression(pattern: "//[^\n]*", options: []) {
            result.append((regex, .comment))
        }

        // Block comments: /* */
        if let regex = try? NSRegularExpression(pattern: "/\\*[\\s\\S]*?\\*/", options: []) {
            result.append((regex, .comment))
        }

        // Numbers: integers and floats
        if let regex = try? NSRegularExpression(pattern: "\\b\\d+\\.?\\d*\\b", options: []) {
            result.append((regex, .number))
        }

        // Headings: =, ==, === at start of line
        if let regex = try? NSRegularExpression(pattern: "^(={1,6})\\s", options: .anchorsMatchLines) {
            result.append((regex, .heading))
        }

        // Bullets: -, +, * at start of line
        if let regex = try? NSRegularExpression(pattern: "^[\\-\\+\\*]\\s", options: .anchorsMatchLines) {
            result.append((regex, .bullet))
        }

        // Function calls: #funcName(
        if let regex = try? NSRegularExpression(pattern: "#([a-zA-Z_][a-zA-Z0-9_]*)\\(", options: []) {
            result.append((regex, .function))
        }

        // Brackets: [], {}, ()
        if let regex = try? NSRegularExpression(pattern: "[\\[\\]{}\\(\\)]", options: []) {
            result.append((regex, .bracket))
        }

        // Operators: =, +, -, *, /, <, >, ==, !=, <=, >=, =>
        if let regex = try? NSRegularExpression(pattern: "(==|!=|<=|>=|=>|[+\\-\\*/<>=])", options: []) {
            result.append((regex, .operator_))
        }

        return result
    }()

    // MARK: - Highlighting

    /// Highlight Typst source code
    /// - Parameter source: Raw Typst code
    /// - Returns: AttributedString with syntax colors applied
    func highlight(_ source: String) -> AttributedString {
        var attributedString = AttributedString(source)
        let nsRange = NSRange(source.startIndex..., in: source)

        // Track ranges to highlight (to avoid overlapping)
        var highlightedRanges: [(NSRange, TokenType)] = []

        for (regex, tokenType) in patterns {
            regex.enumerateMatches(in: source, options: [], range: nsRange) { match, _, _ in
                guard let match = match else { return }
                let range = match.range

                // Check for overlapping
                let overlaps = highlightedRanges.contains { existingRange, _ in
                    NSIntersectionRange(existingRange, range).length > 0
                }

                if !overlaps {
                    highlightedRanges.append((range, tokenType))
                }
            }
        }

        // Sort by range location for consistent application
        highlightedRanges.sort { $0.0.location < $1.0.location }

        // Apply colors
        for (range, tokenType) in highlightedRanges {
            guard let swiftRange = Range(range, in: source) else { continue }

            let startIndex = AttributedString.Index(swiftRange.lowerBound, within: attributedString)
            let endIndex = AttributedString.Index(swiftRange.upperBound, within: attributedString)

            guard let start = startIndex, let end = endIndex else { continue }

            let attributedRange = start..<end

            switch tokenType {
            case .keyword:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.keyword
                attributedString[attributedRange].font = .system(.body, design: .monospaced).bold()
            case .string:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.string
            case .comment:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.comment
            case .number:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.number
            case .heading:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.accentAmber
                attributedString[attributedRange].font = .system(.body, design: .monospaced).bold()
            case .bullet:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.markup
            case .function:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.function
            case .operator_:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.`operator`
            case .bracket:
                attributedString[attributedRange].foregroundColor = DesignSystem.Colors.Syntax.markup
            }
        }

        return attributedString
    }

    /// Create a TextEditor-friendly binding with syntax highlighting
    /// - Parameters:
    ///   - text: Binding to the source text
    /// - Returns: An AttributedString binding for use with TextEditor
    static func attributedBinding(from text: Binding<String>) -> Binding<AttributedString> {
        Binding(
            get: {
                let highlighter = SyntaxHighlighter()
                return highlighter.highlight(text.wrappedValue)
            },
            set: { newValue in
                // Extract plain text from AttributedString
                text.wrappedValue = String(newValue.characters)
            }
        )
    }
}
