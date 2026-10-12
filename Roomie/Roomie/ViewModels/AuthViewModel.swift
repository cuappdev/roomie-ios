//
//  AuthViewModel.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import SwiftUI

extension AuthView {
    @MainActor
    @Observable
    final class ViewModel {

        enum Mode {
            case signIn, signUp

            var title: String { self == .signIn ? "Welcome back" : "Create your account" }
            var cta: String { self == .signIn ? "Sign in" : "Create account" }
            var togglePrompt: String { self == .signIn ? "New here? Create an account" : "Already have an account? Sign in" }
        }

        // MARK: - Properties

        var mode: Mode
        var name = ""
        var email = ""
        var password = ""
        var isLoading = false
        var errorMessage: String?

        private let auth = AuthManager.shared

        init(mode: Mode) {
            self.mode = mode
        }

        var canSubmit: Bool {
            guard !email.isEmpty, password.count >= 6 else { return false }
            if mode == .signUp { return !name.trimmingCharacters(in: .whitespaces).isEmpty }
            return true
        }

        // MARK: - Functions

        func toggleMode() {
            withAnimation(.smooth) {
                mode = (mode == .signIn) ? .signUp : .signIn
            }
            errorMessage = nil
        }

        /// Authenticates and, on success, hands the user to the app session (the owner state).
        func submit(session: AppSession) async {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }

            do {
                let user: User
                switch mode {
                case .signIn:
                    user = try await auth.signIn(email: email, password: password)
                case .signUp:
                    user = try await auth.signUp(name: name, email: email, password: password)
                }
                Haptics.shared.play(.success)
                session.completeAuthentication(with: user)
            } catch {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Please try again."
                Haptics.shared.play(.warning)
            }
        }
    }
}
