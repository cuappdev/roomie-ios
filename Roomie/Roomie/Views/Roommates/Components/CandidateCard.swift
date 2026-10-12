//
//  CandidateCard.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A prospective-roommate card in the Find list: compatibility, budget, and top traits.
struct CandidateCard: View {
    let candidate: RoommateCandidate
    let isLiked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Avatar(initials: candidate.initials, colorHex: candidate.colorHex, size: 52)
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("\(candidate.name), \(candidate.age)")
                            .font(Constants.Typography.headline)
                            .foregroundStyle(Constants.Colors.textPrimary)
                        if isLiked {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(Constants.Colors.accentPink)
                        }
                    }
                    Text("\(candidate.neighborhood) · $\(candidate.budget)/mo")
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Constants.Colors.textSecondary)
                }
                Spacer(minLength: 0)
                CompatibilityRing(score: candidate.compatibility, size: 52)
            }
            Text(candidate.bio)
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textSecondary)
                .lineLimit(2)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    Chip(text: candidate.cleanliness.label, systemImage: "sparkles", colorHex: "A7C7A0")
                    Chip(text: candidate.sleepSchedule.label, systemImage: "moon.fill", colorHex: "8EBAD9")
                    ForEach(candidate.tags.prefix(2), id: \.self) { tag in
                        Chip(text: tag, colorHex: "9A8872")
                    }
                }
            }
        }
        .cardStyle()
    }
}

#Preview {
    CandidateCard(
        candidate: RoommateCandidate(id: "1", name: "Priya Nair", age: 24, initials: "PN", colorHex: "8EBAD9", bio: "PhD student. Quiet weekdays, brunch person on weekends.", neighborhood: "Collegetown", budget: 900, compatibility: 94, cleanliness: .tidy, sleepSchedule: .earlyBird, socialStyle: .balanced, tags: ["Non-smoker", "Has a cat"]),
        isLiked: false
    )
    .padding()
    .background(Constants.Colors.cream)
}
