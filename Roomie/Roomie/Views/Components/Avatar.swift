//
//  Avatar.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A circular initials avatar in a roommate's signature color. Offline by design — no network
/// image fetch — so lists scroll smoothly and previews never hit the wire.
struct Avatar: View {
    let initials: String
    let colorHex: String
    var size: CGFloat = Constants.Layout.avatarSize

    var body: some View {
        Circle()
            .fill(Color(hex: colorHex))
            .overlay(
                Text(initials)
                    .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            )
            .overlay(Circle().strokeBorder(.white.opacity(0.6), lineWidth: 2))
            .frame(width: size, height: size)
    }
}

#Preview {
    HStack {
        Avatar(initials: "ML", colorHex: "8EBAD9")
        Avatar(initials: "LK", colorHex: "F0A9A0")
        Avatar(initials: "SR", colorHex: "A7C7A0", size: 64)
    }
    .padding()
    .background(Constants.Colors.cream)
}
