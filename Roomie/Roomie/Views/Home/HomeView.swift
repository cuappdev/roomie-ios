//
//  HomeView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The household dashboard: a warm greeting, your balance, chores you owe today, and the
/// recent-activity feed. The home base that keeps the apartment running smoothly.
struct HomeView: View {

    // MARK: - Properties

    @State private var viewModel = ViewModel()
    @State private var path: [Route] = []

    enum Route: Hashable {
        case agreements
    }

    // MARK: - UI

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Constants.Colors.cream.ignoresSafeArea()
                content
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .agreements: AgreementsView()
                }
            }
            .errorAlert($viewModel.errorMessage)
        }
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        ScrollView {
            LoadStateView(state: viewModel.state, retry: { Task { await viewModel.load() } }) { data in
                VStack(alignment: .leading, spacing: Constants.Layout.sectionSpacing) {
                    greeting(data)
                    balanceCard(data)
                    choresDue(data)
                    agreementsLink
                    activityFeed(data)
                }
                .padding(Constants.Layout.screenPadding)
            }
        }
        .refreshable { await viewModel.load() }
    }

    // MARK: - Sections

    private func greeting(_ data: ViewModel.Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hi, \(data.user.name.components(separatedBy: " ").first ?? data.user.name) 👋")
                .font(Constants.Typography.largeTitle)
                .foregroundStyle(Constants.Colors.textPrimary)
            Text(data.household.name)
                .font(Constants.Typography.body)
                .foregroundStyle(Constants.Colors.textSecondary)
        }
    }

    private func balanceCard(_ data: ViewModel.Content) -> some View {
        let me = data.household.members.first { $0.id == viewModel.currentUserID }
        let balance = me?.balance ?? 0
        let isOwed = balance >= 0
        return VStack(alignment: .leading, spacing: 12) {
            Text(isOwed ? "You're owed" : "You owe the house")
                .font(Constants.Typography.caption)
                .foregroundStyle(.white.opacity(0.85))
            Text(abs(balance).currencyLabel)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            HStack(spacing: -10) {
                ForEach(data.household.members) { member in
                    Avatar(initials: member.initials, colorHex: member.colorHex, size: 34)
                }
                Spacer()
                Text("\(data.household.members.count) roommates")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [Constants.Colors.primary, Constants.Colors.primaryDark],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius, style: .continuous))
    }

    @ViewBuilder
    private func choresDue(_ data: ViewModel.Content) -> some View {
        VStack(alignment: .leading, spacing: Constants.Layout.itemSpacing) {
            SectionHeader(title: "Your chores today")
            if data.myChoresDue.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Constants.Colors.positive)
                    Text("You're all caught up. Nice work!")
                        .font(Constants.Typography.body)
                        .foregroundStyle(Constants.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle()
            } else {
                ForEach(data.myChoresDue) { chore in
                    HomeChoreRow(chore: chore)
                }
            }
        }
    }

    private var agreementsLink: some View {
        Button {
            path.append(.agreements)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Constants.Colors.accentPink, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text("House agreements")
                        .font(Constants.Typography.callout)
                        .foregroundStyle(Constants.Colors.textPrimary)
                    Text("Keep everyone on the same page")
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Constants.Colors.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Constants.Colors.textTertiary)
            }
            .cardStyle()
        }
        .buttonStyle(.scale)
    }

    private func activityFeed(_ data: ViewModel.Content) -> some View {
        VStack(alignment: .leading, spacing: Constants.Layout.itemSpacing) {
            SectionHeader(title: "Recent activity")
            VStack(spacing: 0) {
                ForEach(Array(data.activity.enumerated()), id: \.element.id) { index, event in
                    ActivityRow(event: event)
                    if index < data.activity.count - 1 {
                        Divider().background(Constants.Colors.border)
                    }
                }
            }
            .cardStyle(padding: 4)
        }
    }
}

#Preview {
    HomeView()
        .environment(AppSession())
}
