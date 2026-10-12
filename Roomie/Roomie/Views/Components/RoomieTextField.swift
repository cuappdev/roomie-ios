//
//  RoomieTextField.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The app's standard text field — an icon, a rounded cream capsule, and optional secure entry.
struct RoomieTextField: View {
    let title: String
    @Binding var text: String
    var icon: String?
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Constants.Colors.textSecondary)
                    .frame(width: 20)
            }
            Group {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .font(Constants.Typography.body)
            .foregroundStyle(Constants.Colors.textPrimary)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Constants.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.controlCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Constants.Layout.controlCornerRadius, style: .continuous)
                .strokeBorder(Constants.Colors.border, lineWidth: 1)
        )
    }
}

#Preview {
    @Previewable @State var text = ""
    VStack {
        RoomieTextField(title: "Email", text: $text, icon: "envelope.fill")
        RoomieTextField(title: "Password", text: $text, icon: "lock.fill", isSecure: true)
    }
    .padding()
    .background(Constants.Colors.cream)
}
