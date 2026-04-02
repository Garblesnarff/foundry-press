import Foundation
import os.log

/// Logging utility for debugging and diagnostics
class Logger {
    private static let log = OSLog(subsystem: "com.foundry.press", category: "general")

    enum LogLevel {
        case debug
        case info
        case warning
        case error
    }

    static func log(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent

        let formattedMessage = "[\(fileName):\(line)] \(function): \(message)"

        switch level {
        case .debug:
            os_log("[DEBUG] %{public}@", log: log, type: .debug, formattedMessage)
        case .info:
            os_log("[INFO] %{public}@", log: log, type: .info, formattedMessage)
        case .warning:
            os_log("[WARNING] %{public}@", log: log, type: .default, formattedMessage)
        case .error:
            os_log("[ERROR] %{public}@", log: log, type: .error, formattedMessage)
        }
    }

    static func debug(_ message: String) {
        log(message, level: .debug)
    }

    static func info(_ message: String) {
        log(message, level: .info)
    }

    static func warning(_ message: String) {
        log(message, level: .warning)
    }

    static func error(_ message: String) {
        log(message, level: .error)
    }
}
