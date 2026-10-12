//
//  AppSession.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import SwiftUI

/// App-wide session state. This is the one view model the `App` itself switches on, and the one
/// piece of state injected through the environment (auth/session is the sanctioned exception).
@MainActor
@Observable
final class AppSession {

    enum State: Equatable {
        case loading
        case onboarding
        case authenticated
    }

    // MARK: - Properties

    var state: State = .loading
    var currentUser: User?

    // MARK: - Functions

    /// Restores a persisted session on launch, falling back to onboarding.
    func bootstrap() async {
        if let user = await AuthManager.shared.restoreSession() {
            currentUser = user
            state = .authenticated
        } else {
            state = .onboarding
        }
    }

    func completeAuthentication(with user: User) {
        currentUser = user
        withAnimation(.smooth) { state = .authenticated }
    }

    func signOut() {
        AuthManager.shared.signOut()
        currentUser = nil
        withAnimation(.smooth) { state = .onboarding }
    }
}
