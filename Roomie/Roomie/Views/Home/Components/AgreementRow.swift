//
//  AgreementRow.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A house agreement with its sign-off progress and an "I agree" toggle.
struct AgreementRow: View {
    let agreement: Agreement
    let memberCount: Int
    let hasAgreed: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: agreement.category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Constants.Colors.primary)
                    .frame(width: 40, height: 40)
                    .background(Constants.Colors.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text(agreement.title)
                        .font(Constants.Typography.callout)
                        .foregroundStyle(Constants.Colors.textPrimary)
                    Text(agreement.category.label)
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Constants.Colors.textSecondary)
                }
                Spacer(minLength: 0)
            }

            Text(agreement.detail)
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Label("\(agreement.agreedBy.count) of \(memberCount) agreed", systemImage: "person.2.fill")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
                Spacer()
                Button(action: toggle) {
                    Label(hasAgreed ? "Agreed" : "I agree", systemImage: hasAgreed ? "checkmark.circle.fill" : "hand.raised")
                        .font(Constants.Typography.caption)
                        .foregroundStyle(hasAgreed ? .white : Constants.Colors.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            hasAgreed ? Constants.Colors.positive : Constants.Colors.primary.opacity(0.12),
                            in: Capsule()
                        )
                }
                .buttonStyle(.scale)
            }
        }
        .cardStyle()
    }
}

#Preview {
    AgreementRow(
        agreement: Agreement(id: "1", title: "Quiet hours after 11pm", detail: "Keep music and calls low-volume after 11pm on weeknights.", category: .quietHours, agreedBy: ["u1", "u2", "u3"]),
        memberCount: 4,
        hasAgreed: true,
        toggle: {}
    )
    .padding()
    .background(Constants.Colors.cream)
}
