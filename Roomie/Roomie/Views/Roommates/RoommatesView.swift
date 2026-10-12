//
//  RoommatesView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Two sides of living together: the people you live with now, and finding the right person for
/// an open room.
struct RoommatesView: View {

    // MARK: - Properties

    @State private var viewModel = ViewModel()
    @State private var path: [Route] = []

    enum Route: Hashable {
        case roommate(Roommate)
        case candidate(RoommateCandidate)
    }

    // MARK: - UI

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Constants.Colors.cream.ignoresSafeArea()
                VStack(spacing: Constants.Layout.itemSpacing) {
                    segmentPicker
                    content
                }
                .padding(.top, Constants.Layout.itemSpacing)
            }
            .navigationTitle("Roommates")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .roommate(let roommate):
                    RoommateDetailView(roommate: roommate)
                case .candidate(let candidate):
                    CandidateDetailView(candidate: candidate, viewModel: viewModel)
                }
            }
            .errorAlert($viewModel.errorMessage)
        }
        .task { await viewModel.load() }
    }

    private var segmentPicker: some View {
        Picker("Segment", selection: $viewModel.segment) {
            ForEach(ViewModel.Segment.allCases) { segment in
                Text(segment.rawValue).tag(segment)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, Constants.Layout.screenPadding)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.segment {
        case .house: houseList
        case .find: findList
        }
    }

    private var houseList: some View {
        ScrollView {
            LoadStateView(state: viewModel.houseState, retry: { Task { await viewModel.loadHouse() } }) { household in
                VStack(spacing: Constants.Layout.itemSpacing) {
                    inviteCard(household)
                    ForEach(household.members) { member in
                        Button {
                            path.append(.roommate(member))
                        } label: {
                            RoommateCard(roommate: member)
                        }
                        .buttonStyle(.scale)
                    }
                }
                .padding(Constants.Layout.screenPadding)
            }
        }
        .refreshable { await viewModel.loadHouse() }
    }

    private var findList: some View {
        ScrollView {
            LoadStateView(
                state: viewModel.findState,
                emptyIcon: "sparkle.magnifyingglass",
                emptyTitle: "You've seen everyone",
                emptyMessage: "Check back later for new roommate matches.",
                retry: { Task { await viewModel.loadCandidates() } }
            ) { candidates in
                VStack(spacing: Constants.Layout.itemSpacing) {
                    if viewModel.matchCount > 0 {
                        matchBanner
                    }
                    ForEach(candidates) { candidate in
                        Button {
                            path.append(.candidate(candidate))
                        } label: {
                            CandidateCard(candidate: candidate, isLiked: viewModel.isLiked(candidate))
                        }
                        .buttonStyle(.scale)
                    }
                }
                .padding(Constants.Layout.screenPadding)
            }
        }
        .refreshable { await viewModel.loadCandidates() }
    }

    private func inviteCard(_ household: Household) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Constants.Colors.accentGreen, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text("Invite a roommate")
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text("Code: \(household.inviteCode)")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            Spacer()
            ShareLink(item: "Join our Roomie house with code \(household.inviteCode)") {
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(Constants.Colors.primary)
            }
        }
        .cardStyle()
    }

    private var matchBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "heart.fill")
                .foregroundStyle(Constants.Colors.accentPink)
            Text("\(viewModel.matchCount) connection\(viewModel.matchCount == 1 ? "" : "s") sent")
                .font(Constants.Typography.callout)
                .foregroundStyle(Constants.Colors.textPrimary)
            Spacer()
        }
        .cardStyle()
    }
}

#Preview {
    RoommatesView()
}
