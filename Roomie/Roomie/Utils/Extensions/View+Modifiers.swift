//
//  View+Modifiers.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

// MARK: - Loading overlay

private struct LoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content.overlay {
            if isLoading {
                ZStack {
                    Constants.Colors.cream.opacity(0.6)
                    ProgressView()
                        .tint(Constants.Colors.primary)
                        .scaleEffect(1.2)
                }
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - Error alert

private struct ErrorAlertModifier: ViewModifier {
    @Binding var message: String?

    func body(content: Content) -> some View {
        content.alert(
            "Something went wrong",
            isPresented: Binding(
                get: { message != nil },
                set: { if !$0 { message = nil } }
            ),
            actions: { Button("OK", role: .cancel) { message = nil } },
            message: { Text(message ?? "") }
        )
    }
}

// MARK: - Card styling

private struct CardModifier: ViewModifier {
    var padding: CGFloat = Constants.Layout.cardPadding

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Constants.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius, style: .continuous)
                    .strokeBorder(Constants.Colors.border, lineWidth: 1)
            )
            .shadow(color: Constants.Colors.primaryDark.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

extension View {
    /// Dims the view and shows a centered spinner while `isLoading` is true.
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }

    /// Presents a shared error alert whenever `message` is non-nil, clearing it on dismiss.
    func errorAlert(_ message: Binding<String?>) -> some View {
        modifier(ErrorAlertModifier(message: message))
    }

    /// Wraps the view in the app's standard rounded, bordered card surface.
    func cardStyle(padding: CGFloat = Constants.Layout.cardPadding) -> some View {
        modifier(CardModifier(padding: padding))
    }
}
