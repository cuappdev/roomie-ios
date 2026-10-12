//
//  Keys.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// Reads configuration values (base URLs, client IDs, secrets) from the app bundle's
/// Info.plist. Never hardcode secrets at a call site — add a key here and a matching
/// entry in the (git-ignored) config so a missing value shows up loudly.
enum Keys {
    /// Base URL for the Roomie REST API.
    static var apiBaseURL: String {
        value(for: "API_BASE_URL", default: "https://api.roomie.example.com")
    }

    private static func value(for key: String, default defaultValue: String) -> String {
        Bundle.main.object(forInfoDictionaryKey: key) as? String ?? defaultValue
    }
}
