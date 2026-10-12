//
//  RoommateCard.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A current-household member row: avatar, name, chores done, and net balance.
struct RoommateCard: View {
    let roommate: Roommate

    var body: some View {
        HStack(spacing: 14) {
            Avatar(initials: roommate.initials, colorHex: roommate.colorHex, size: 48)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(roommate.name)
                        .font(Constants.Typography.callout)
                        .foregroundStyle(Constants.Colors.textPrimary)
                    if roommate.isCurrentUser {
                        Chip(text: "You", colorHex: "8EBAD9")
                    }
                }
                Text("\(roommate.choresCompletedThisWeek) chores done this week")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 2) {
                Text(abs(roommate.balance).currencyLabel)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(roommate.balance >= 0 ? Constants.Colors.positive : Constants.Colors.negative)
                Text(roommate.balance >= 0 ? "owed" : "owes")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
        }
        .cardStyle()
    }
}

#Preview {
    RoommateCard(roommate: Roommate(id: "u1", name: "Mina Liu", initials: "ML", colorHex: "8EBAD9", isCurrentUser: true, balance: 124.50, choresCompletedThisWeek: 4))
        .padding()
        .background(Constants.Colors.cream)
}
