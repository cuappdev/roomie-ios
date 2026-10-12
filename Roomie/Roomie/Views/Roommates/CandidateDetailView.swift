//
//  CandidateDetailView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Full profile for a prospective roommate, with pass / connect actions that run on the
/// `RoommatesView.ViewModel` (the owner state).
struct CandidateDetailView: View {

    // MARK: - Properties

    let candidate: RoommateCandidate
    var viewModel: RoommatesView.ViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - UI

    var body: some View {
        ScrollView {
            VStack(spacing: Constants.Layout.sectionSpacing) {
                header
                about
                lifestyle
                tags
            }
            .padding(Constants.Layout.screenPadding)
            .padding(.bottom, 100)
        }
        .background(Constants.Colors.cream)
        .navigationTitle(candidate.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { actionBar }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Avatar(initials: candidate.initials, colorHex: candidate.colorHex, size: 96)
            Text("\(candidate.name), \(candidate.age)")
                .font(Constants.Typography.title)
                .foregroundStyle(Constants.Colors.textPrimary)
            Text("\(candidate.neighborhood) · $\(candidate.budget)/mo")
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textSecondary)
            CompatibilityRing(score: candidate.compatibility, size: 84)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var about: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(Constants.Typography.headline)
                .foregroundStyle(Constants.Colors.textPrimary)
            Text(candidate.bio)
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cardStyle()
    }

    private var lifestyle: some View {
        VStack(alignment: .leading, spacing: Constants.Layout.itemSpacing) {
            SectionHeader(title: "Lifestyle")
            HStack(spacing: Constants.Layout.itemSpacing) {
                StatTile(title: "Cleanliness", value: candidate.cleanliness.label, caption: "habits", colorHex: "A7C7A0")
                StatTile(title: "Sleep", value: candidate.sleepSchedule.label, caption: "schedule", colorHex: "8EBAD9")
            }
            StatTile(title: "Social style", value: candidate.socialStyle.label, caption: "at home", colorHex: "F2CE6B")
        }
    }

    private var tags: some View {
        VStack(alignment: .leading, spacing: Constants.Layout.itemSpacing) {
            SectionHeader(title: "Good to know")
            FlowTags(tags: candidate.tags)
        }
    }

    private var actionBar: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.pass(candidate)
                dismiss()
            } label: {
                Label("Pass", systemImage: "xmark")
                    .font(Constants.Typography.headline)
                    .foregroundStyle(Constants.Colors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Constants.Colors.card)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.controlCornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.Layout.controlCornerRadius, style: .continuous)
                            .strokeBorder(Constants.Colors.border, lineWidth: 1)
                    )
            }
            .buttonStyle(.scale)

            PrimaryButton(title: viewModel.isLiked(candidate) ? "Sent" : "Connect", icon: "heart.fill") {
                viewModel.like(candidate)
                dismiss()
            }
        }
        .padding(Constants.Layout.screenPadding)
        .background(.ultraThinMaterial)
    }
}

/// Simple wrapping tag layout.
struct FlowTags: View {
    let tags: [String]

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Chip(text: tag, colorHex: "9A8872")
            }
        }
    }
}

/// A minimal flow layout that wraps its subviews onto new lines as needed.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widestRow: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            widestRow = max(widestRow, x - spacing)
        }
        return CGSize(width: min(maxWidth, widestRow), height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        CandidateDetailView(
            candidate: RoommateCandidate(id: "1", name: "Priya Nair", age: 24, initials: "PN", colorHex: "8EBAD9", bio: "PhD student in CS. Quiet weekdays, brunch person on weekends. Looking for a clean, calm place.", neighborhood: "Collegetown", budget: 900, compatibility: 94, cleanliness: .tidy, sleepSchedule: .earlyBird, socialStyle: .balanced, tags: ["Non-smoker", "Has a cat", "Vegetarian"]),
            viewModel: RoommatesView.ViewModel()
        )
    }
}
