//
//  PrimaryButton.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The app's primary call-to-action button — full-width, brown, rounded, with a loading state.
struct PrimaryButton: View {
    let title: String
    var icon: String?
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    if let icon { Image(systemName: icon) }
                    Text(title)
                }
            }
            .font(Constants.Typography.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Constants.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.controlCornerRadius, style: .continuous))
            .opacity(isEnabled && !isLoading ? 1 : 0.5)
        }
        .buttonStyle(.scale)
        .disabled(!isEnabled || isLoading)
    }
}

/// A lighter, bordered secondary button.
struct SecondaryButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title)
            }
            .font(Constants.Typography.callout)
            .foregroundStyle(Constants.Colors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Constants.Colors.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.controlCornerRadius, style: .continuous))
        }
        .buttonStyle(.scale)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continue", icon: "arrow.right", action: {})
        PrimaryButton(title: "Loading", isLoading: true, action: {})
        SecondaryButton(title: "Skip", action: {})
    }
    .padding()
    .background(Constants.Colors.cream)
}
