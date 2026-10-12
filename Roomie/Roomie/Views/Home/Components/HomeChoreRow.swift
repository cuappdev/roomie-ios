//
//  HomeChoreRow.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Compact read-only chore row for the Home dashboard.
struct HomeChoreRow: View {
    let chore: Chore

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: chore.icon)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Constants.Colors.primary)
                .frame(width: 42, height: 42)
                .background(Constants.Colors.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(chore.title)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text(chore.dueDate.isOverdue ? "Overdue" : "Due \(chore.dueDate.relativeDayLabel.lowercased())")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(chore.dueDate.isOverdue ? Constants.Colors.negative : Constants.Colors.textSecondary)
            }
            Spacer()
        }
        .cardStyle()
    }
}

#Preview {
    HomeChoreRow(chore: Chore(id: "1", title: "Take out trash", icon: "trash.fill", assigneeID: "u1", assigneeName: "Mina", dueDate: .now, recurrence: .weekly, isDone: false))
        .padding()
        .background(Constants.Colors.cream)
}
