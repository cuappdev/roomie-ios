//
//  SectionHeader.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A section title with an optional trailing action (e.g. "See all").
struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(Constants.Typography.headline)
                .foregroundStyle(Constants.Colors.textPrimary)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.primary)
            }
        }
    }
}

/// A small rounded tag used for lifestyle traits, categories, and recurrence labels.
struct Chip: View {
    let text: String
    var systemImage: String?
    var colorHex: String = "9B7B58"

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage { Image(systemName: systemImage).font(.system(size: 11, weight: .semibold)) }
            Text(text)
                .lineLimit(1)
        }
        .font(Constants.Typography.caption)
        .foregroundStyle(Color(hex: colorHex))
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(hex: colorHex).opacity(0.14), in: Capsule())
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        SectionHeader(title: "Recent activity", actionTitle: "See all", action: {})
        HStack {
            Chip(text: "Weekly", systemImage: "repeat", colorHex: "8EBAD9")
            Chip(text: "Non-smoker", colorHex: "A7C7A0")
        }
    }
    .padding()
    .background(Constants.Colors.cream)
}
