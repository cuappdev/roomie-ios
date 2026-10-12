//
//  AppLogger.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import OSLog

/// Centralized OSLog loggers, categorized by concern. Use these instead of `print`.
enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "org.cuappdev.Roomie"

    static let services = Logger(subsystem: subsystem, category: "services")
    static let data = Logger(subsystem: subsystem, category: "data")
    static let ui = Logger(subsystem: subsystem, category: "ui")
}
