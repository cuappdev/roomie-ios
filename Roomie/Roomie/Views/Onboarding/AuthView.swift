//
//  AuthView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Sign in / sign up screen. Authenticates through its view model, which hands the user back to
/// the app `AppSession` on success.
struct AuthView: View {

    // MARK: - Properties

    @Environment(AppSession.self) private var session
    @State private var viewModel: ViewModel
    @FocusState private var focusedField: Field?

    private enum Field { case name, email, password }

    init(mode: ViewModel.Mode) {
        _viewModel = State(initialValue: ViewModel(mode: mode))
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            Constants.Colors.backgroundGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: Constants.Layout.sectionSpacing) {
                    header
                    form
                    submitButton
                    toggleModeButton
                }
                .padding(Constants.Layout.screenPadding)
                .padding(.top, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert($viewModel.errorMessage)
        .onSubmit(advanceFocus)
    }

    private var header: some View {
        VStack(spacing: 12) {
            RoomieLogo(size: 80)
            Text(viewModel.mode.title)
                .font(Constants.Typography.title)
                .foregroundStyle(Constants.Colors.textPrimary)
        }
        .padding(.bottom, 4)
    }

    private var form: some View {
        VStack(spacing: Constants.Layout.itemSpacing) {
            if viewModel.mode == .signUp {
                RoomieTextField(title: "Full name", text: $viewModel.name, icon: "person.fill")
                    .focused($focusedField, equals: .name)
                    .textContentType(.name)
            }
            RoomieTextField(title: "Email", text: $viewModel.email, icon: "envelope.fill")
                .focused($focusedField, equals: .email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            RoomieTextField(title: "Password", text: $viewModel.password, icon: "lock.fill", isSecure: true)
                .focused($focusedField, equals: .password)
                .textContentType(.password)
        }
    }

    private var submitButton: some View {
        PrimaryButton(
            title: viewModel.mode.cta,
            isLoading: viewModel.isLoading,
            isEnabled: viewModel.canSubmit
        ) {
            focusedField = nil
            Task { await viewModel.submit(session: session) }
        }
    }

    private var toggleModeButton: some View {
        Button(viewModel.mode.togglePrompt) {
            viewModel.toggleMode()
        }
        .font(Constants.Typography.callout)
        .foregroundStyle(Constants.Colors.primary)
    }

    // MARK: - Private

    private func advanceFocus() {
        switch focusedField {
        case .name: focusedField = .email
        case .email: focusedField = .password
        default: focusedField = nil
        }
    }
}

#Preview {
    NavigationStack {
        AuthView(mode: .signUp)
            .environment(AppSession())
    }
}
