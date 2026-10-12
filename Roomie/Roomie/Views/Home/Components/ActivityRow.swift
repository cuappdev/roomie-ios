//
//  ActivityRow.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A single row in the household's recent-activity feed.
struct ActivityRow: View {
    let event: ActivityEvent

    var body: some View {
        HStack(spacing: 12) {
            Avatar(initials: event.actorInitials, colorHex: event.actorColorHex, size: 38)
            VStack(alignment: .leading, spacing: 2) {
                Text(summaryText)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Constants.Colors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(event.timestamp.formatted(.relative(presentation: .named)))
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            Spacer(minLength: 0)
            Image(systemName: event.kind.icon)
                .font(.system(size: 14))
                .foregroundStyle(Constants.Colors.textTertiary)
        }
        .padding(12)
    }

    /// The actor's name in bold, followed by the plain-text summary.
    private var summaryText: AttributedString {
        var name = AttributedString(event.actorName)
        name.inlinePresentationIntent = .stronglyEmphasized
        return name + AttributedString(" \(event.summary)")
    }
}

#Preview {
    ActivityRow(event: ActivityEvent(id: "1", actorName: "Leah Kim", actorInitials: "LK", actorColorHex: "F0A9A0", kind: .expense, summary: "added “Pizza night” — $52.00", timestamp: .now.addingTimeInterval(-3600)))
        .background(Constants.Colors.card)
}
