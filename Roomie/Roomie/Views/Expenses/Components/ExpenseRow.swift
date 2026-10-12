//
//  ExpenseRow.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A single shared expense: category icon, who paid, and the amount with your share.
struct ExpenseRow: View {
    let expense: Expense
    let currentUserID: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: expense.category.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(Color(hex: expense.category.colorHex), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(expense.title)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text("\(paidByLabel) · \(expense.date.relativeDayLabel)")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 3) {
                Text(expense.amount.currencyLabel)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.textPrimary)
                if expense.splitAmong.contains(currentUserID) {
                    Text("you: \(expense.shareEach.currencyLabel)")
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Constants.Colors.textSecondary)
                }
            }
        }
        .cardStyle()
    }

    private var paidByLabel: String {
        expense.paidByID == currentUserID ? "You paid" : "\(expense.paidByName) paid"
    }
}

#Preview {
    ExpenseRow(
        expense: Expense(id: "1", title: "October rent", amount: 3200, paidByID: "u1", paidByName: "Mina Liu", date: .now, category: .rent, splitAmong: ["u1", "u2", "u3", "u4"]),
        currentUserID: "u1"
    )
    .padding()
    .background(Constants.Colors.cream)
}
