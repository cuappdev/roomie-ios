//
//  StateViews.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Friendly empty state — a soft icon, a title, and a short line of guidance.
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 44, weight: .regular))
                .foregroundStyle(Constants.Colors.primary.opacity(0.7))
                .padding(24)
                .background(Constants.Colors.primary.opacity(0.08), in: Circle())
            Text(title)
                .font(Constants.Typography.headline)
                .foregroundStyle(Constants.Colors.textPrimary)
            Text(message)
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textSecondary)
                .multilineTextAlignment(.center)
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.primary)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
    }
}

/// Error state with a retry affordance.
struct ErrorStateView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(Constants.Colors.negative)
            Text(message)
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textSecondary)
                .multilineTextAlignment(.center)
            Button("Try again", action: retry)
                .font(Constants.Typography.callout)
                .foregroundStyle(Constants.Colors.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
    }
}

/// Switches over a `LoadState`, rendering a spinner, the loaded content, an empty state, or an
/// error with retry — so every content screen handles all four cases the same way.
struct LoadStateView<Value, Content: View>: View {
    let state: LoadState<Value>
    var emptyIcon: String = "tray"
    var emptyTitle: String = "Nothing here yet"
    var emptyMessage: String = "Check back soon."
    let retry: () -> Void
    @ViewBuilder let content: (Value) -> Content

    var body: some View {
        switch state {
        case .loading:
            ProgressView()
                .tint(Constants.Colors.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
        case .loaded(let value):
            content(value)
        case .empty:
            EmptyStateView(icon: emptyIcon, title: emptyTitle, message: emptyMessage)
        case .error(let message):
            ErrorStateView(message: message, retry: retry)
        }
    }
}
