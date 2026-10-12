//
//  RoommateDetailView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Read-only profile for a current household member. No business logic, so no view model.
struct RoommateDetailView: View {
    let roommate: Roommate

    var body: some View {
        ScrollView {
            VStack(spacing: Constants.Layout.sectionSpacing) {
                header
                statsRow
            }
            .padding(Constants.Layout.screenPadding)
        }
        .background(Constants.Colors.cream)
        .navigationTitle(roommate.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Avatar(initials: roommate.initials, colorHex: roommate.colorHex, size: 96)
            Text(roommate.name)
                .font(Constants.Typography.title)
                .foregroundStyle(Constants.Colors.textPrimary)
            if roommate.isCurrentUser {
                Chip(text: "This is you", colorHex: "8EBAD9")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }

    private var statsRow: some View {
        HStack(spacing: Constants.Layout.itemSpacing) {
            StatTile(
                title: "Balance",
                value: abs(roommate.balance).currencyLabel,
                caption: roommate.balance >= 0 ? "owed to them" : "they owe",
                colorHex: roommate.balance >= 0 ? "6FA880" : "D98C7A"
            )
            StatTile(
                title: "Chores",
                value: "\(roommate.choresCompletedThisWeek)",
                caption: "done this week",
                colorHex: "9B7B58"
            )
        }
    }
}

/// A small labeled metric tile.
struct StatTile: View {
    let title: String
    let value: String
    let caption: String
    var colorHex: String = "9B7B58"

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(Constants.Typography.caption)
                .foregroundStyle(Constants.Colors.textSecondary)
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: colorHex))
            Text(caption)
                .font(Constants.Typography.caption)
                .foregroundStyle(Constants.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

#Preview {
    NavigationStack {
        RoommateDetailView(roommate: Roommate(id: "u1", name: "Mina Liu", initials: "ML", colorHex: "8EBAD9", isCurrentUser: false, balance: 124.50, choresCompletedThisWeek: 4))
    }
}
