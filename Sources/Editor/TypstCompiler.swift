import Foundation

/// FFI bridge to Typst compiler (Rust via C)
///
/// Manages compilation lifecycle:
/// - Compiles .typ files to PDF bytes
/// - Watches for changes and recompiles
/// - Thread-safe (runs on background queue)
///
/// Note: Currently uses mock compilation for testing.
/// Real implementation will use C FFI to Typst Rust library.
class TypstCompiler {
    private let queue = DispatchQueue(label: "com.foundry.press.compiler", qos: .userInitiated)

    // MARK: - Compilation

    /// Compile Typst source to PDF
    /// - Parameters:
    ///   - source: Typst source code
    ///   - completion: Callback with PDF bytes or error
    func compile(source: String, completion: @escaping (Result<Data, Error>) -> Void) {
        queue.async { [weak self] in
            let result = self?.performCompilation(source: source) ?? .failure(CompilerError.internalError)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    /// Get compilation diagnostics (warnings, errors)
    /// - Parameter source: Typst source code
    /// - Returns: Array of diagnostic messages
    func getDiagnostics(source: String) -> [Diagnostic] {
        var diagnostics: [Diagnostic] = []

        // Check for common syntax errors
        if source.contains("#let") && !source.contains("=") && source.contains("#let") {
            // This is a simplified check
        }

        return diagnostics
    }

    // MARK: - Mock Compilation

    private func performCompilation(source: String) -> Result<Data, Error> {
        // Simulate compilation delay (real Typst compiles in ~100-500ms)
        Thread.sleep(forTimeInterval: 0.2)

        // Check for obvious syntax errors in mock
        let syntaxError = checkForMockSyntaxErrors(source)
        if let error = syntaxError {
            return .failure(error)
        }

        // Generate mock PDF data
        // In real implementation, this would call the Typst Rust library via C FFI
        let mockPDF = generateMockPDF(for: source)
        return .success(mockPDF)
    }

    private func checkForMockSyntaxErrors(_ source: String) -> Error? {
        // Check for unbalanced brackets
        let openBrackets = source.filter { $0 == "{" || $0 == "[" || $0 == "(" }.count
        let closeBrackets = source.filter { $0 == "}" || $0 == "]" || $0 == ")" }.count

        if openBrackets != closeBrackets {
            return CompilerError.syntaxError("Unbalanced brackets: expected \(openBrackets) closing brackets, found \(closeBrackets)")
        }

        // Check for unmatched string quotes
        var inString = false
        var escape = false
        for char in source {
            if char == "\\" && inString {
                escape = true
                continue
            }
            if char == "\"" && !escape {
                inString = !inString
            }
            escape = false
        }

        if inString {
            return CompilerError.syntaxError("Unterminated string literal")
        }

        return nil
    }

    private func generateMockPDF(for source: String) -> Data {
        // Create a minimal valid PDF that displays the source
        // This is a placeholder - real implementation uses Typst compiler
        let pdfContent = """
        %PDF-1.4
        1 0 obj
        << /Type /Catalog /Pages 2 0 R >>
        endobj
        2 0 obj
        << /Type /Pages /Kids [3 0 R] /Count 1 >>
        endobj
        3 0 obj
        << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>
        endobj
        4 0 obj
        << /Length \(source.count + 100) >>
        stream
        BT
        /F1 12 Tf
        50 700 Td
        (Mock Preview - Source:) Tj
        0 -20 Td
        (\(source.prefix(50).replacingOccurrences(of: "(", with: "\\(").replacingOccurrences(of: ")", with: "\\)"))) Tj
        ET
        endstream
        endobj
        5 0 obj
        << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>
        endobj
        xref
        0 6
        0000000000 65535 f
        0000000009 00000 n
        0000000058 00000 n
        0000000115 00000 n
        0000000266 00000 n
        0000000\(source.count + 400) 00000 n
        trailer
        << /Size 6 /Root 1 0 R >>
        startxref
        \(source.count + 500)
        %%EOF
        """

        return pdfContent.data(using: .utf8) ?? Data()
    }
}

// MARK: - Error Types

enum CompilerError: Error, LocalizedError {
    case syntaxError(String)
    case internalError
    case compilationFailed(String)

    var errorDescription: String? {
        switch self {
        case .syntaxError(let message):
            return "Syntax Error: \(message)"
        case .internalError:
            return "Internal compiler error"
        case .compilationFailed(let message):
            return "Compilation failed: \(message)"
        }
    }
}

struct Diagnostic {
    let message: String
    let severity: Severity
    let line: Int?
    let column: Int?

    enum Severity {
        case error
        case warning
        case info
    }
}
