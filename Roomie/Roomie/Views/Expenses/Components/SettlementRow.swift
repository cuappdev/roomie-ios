//
//  SettlementRow.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A "who pays whom" line, framed from the current user's perspective where relevant.
struct SettlementRow: View {
    let settlement: Settlement
    let currentUserID: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(tint, in: Circle())
            Text(label)
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            Text(settlement.amount.currencyLabel)
                .font(Constants.Typography.headline)
                .foregroundStyle(tint)
        }
        .padding(12)
    }

    private var isPayer: Bool { settlement.fromID == currentUserID }
    private var isPayee: Bool { settlement.toID == currentUserID }

    private var label: String {
        if isPayer { return "You owe \(settlement.toName)" }
        if isPayee { return "\(settlement.fromName) owes you" }
        return "\(settlement.fromName) owes \(settlement.toName)"
    }

    private var tint: Color {
        if isPayer { return Constants.Colors.negative }
        if isPayee { return Constants.Colors.positive }
        return Constants.Colors.textSecondary
    }

    private var icon: String {
        isPayer ? "arrow.up.right" : "arrow.down.left"
    }
}

#Preview {
    VStack {
        SettlementRow(settlement: Settlement(fromID: "u1", fromName: "Mina", toID: "u2", toName: "Leah", amount: 42.50), currentUserID: "u1")
        SettlementRow(settlement: Settlement(fromID: "u3", fromName: "Sam", toID: "u1", toName: "Mina", amount: 18.00), currentUserID: "u1")
    }
    .background(Constants.Colors.card)
}
