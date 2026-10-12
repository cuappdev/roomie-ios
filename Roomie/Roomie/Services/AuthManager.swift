//
//  AuthManager.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation
import OSLog

/// Owns authentication and the access token. Call sites never touch tokens directly — they ask
/// `AuthManager` to sign in/up/out, and the networking layer reads `accessToken` / `refresh()`.
///
/// This is a mock implementation (no live backend yet): it validates input shape, persists a
/// fake token, and returns a seeded user.
final class AuthManager {
    static let shared = AuthManager()
    private init() {
        accessToken = UserDefaults.standard.string(forKey: Self.tokenKey)
    }

    private static let tokenKey = "roomie.accessToken"

    /// The current bearer token, or `nil` when signed out.
    private(set) var accessToken: String?

    var isSignedIn: Bool { accessToken != nil }

    // MARK: - Functions

    /// Signs in and returns the user. Throws `AuthError` on bad input.
    func signIn(email: String, password: String) async throws -> User {
        try await authenticate(email: email, password: password, name: nil)
    }

    /// Creates an account and returns the new user.
    func signUp(name: String, email: String, password: String) async throws -> User {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { throw AuthError.invalidName }
        return try await authenticate(email: email, password: password, name: name)
    }

    func signOut() {
        accessToken = nil
        UserDefaults.standard.removeObject(forKey: Self.tokenKey)
        AppLogger.services.info("User signed out")
    }

    /// Restores a previously signed-in user, if a token is persisted.
    func restoreSession() async -> User? {
        guard isSignedIn else { return nil }
        return MockDataService.shared.currentUser
    }

    /// Refreshes the access token. Mock: re-issues a token.
    func refresh() async throws {
        accessToken = Self.makeToken()
        UserDefaults.standard.set(accessToken, forKey: Self.tokenKey)
    }

    // MARK: - Private

    private func authenticate(email: String, password: String, name: String?) async throws -> User {
        guard email.contains("@"), email.contains(".") else { throw AuthError.invalidEmail }
        guard password.count >= 6 else { throw AuthError.weakPassword }

        try? await Task.sleep(for: .milliseconds(700))

        accessToken = Self.makeToken()
        UserDefaults.standard.set(accessToken, forKey: Self.tokenKey)

        var user = MockDataService.shared.currentUser
        if let name, !name.isEmpty {
            user.name = name
            user.initials = Self.initials(from: name)
        }
        user.email = email
        MockDataService.shared.currentUser = user
        AppLogger.services.info("User authenticated")
        return user
    }

    private static func makeToken() -> String { UUID().uuidString }

    private static func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }
}

enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case invalidName

    var errorDescription: String? {
        switch self {
        case .invalidEmail: "Please enter a valid email address."
        case .weakPassword: "Your password needs to be at least 6 characters."
        case .invalidName: "Please tell us your name."
        }
    }
}
