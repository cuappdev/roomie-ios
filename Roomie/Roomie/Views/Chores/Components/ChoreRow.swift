//
//  ChoreRow.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// An interactive chore row: tap the check to complete, with assignee and due date.
struct ChoreRow: View {
    let chore: Chore
    let toggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: toggle) {
                Image(systemName: chore.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 26))
                    .foregroundStyle(chore.isDone ? Constants.Colors.positive : Constants.Colors.textTertiary)
            }
            .buttonStyle(.scale)

            Image(systemName: chore.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Constants.Colors.primary)
                .frame(width: 40, height: 40)
                .background(Constants.Colors.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 11, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(chore.title)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.textPrimary)
                    .strikethrough(chore.isDone, color: Constants.Colors.textSecondary)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(chore.assigneeName)
                        .lineLimit(1)
                    Text("·")
                    Text(dueLabel)
                        .foregroundStyle(dueColor)
                        .fixedSize()
                    Chip(text: chore.recurrence.label, systemImage: "repeat", colorHex: "9A8872")
                    Spacer(minLength: 0)
                }
                .font(Constants.Typography.caption)
                .foregroundStyle(Constants.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(chore.isDone ? 0.6 : 1)
        .cardStyle()
    }

    private var dueLabel: String {
        chore.isDone ? "Done" : (chore.dueDate.isOverdue ? "Overdue" : "Due \(chore.dueDate.relativeDayLabel.lowercased())")
    }

    private var dueColor: Color {
        if chore.isDone { return Constants.Colors.textSecondary }
        return chore.dueDate.isOverdue ? Constants.Colors.negative : Constants.Colors.textSecondary
    }
}

#Preview {
    VStack {
        ChoreRow(chore: Chore(id: "1", title: "Do the dishes", icon: "dishwasher.fill", assigneeID: "u1", assigneeName: "Mina Liu", dueDate: .now, recurrence: .daily, isDone: false), toggle: {})
        ChoreRow(chore: Chore(id: "2", title: "Vacuum", icon: "wind", assigneeID: "u2", assigneeName: "Leah Kim", dueDate: .now, recurrence: .weekly, isDone: true), toggle: {})
    }
    .padding()
    .background(Constants.Colors.cream)
}
