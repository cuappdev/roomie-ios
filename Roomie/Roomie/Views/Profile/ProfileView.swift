//
//  ProfileView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The signed-in user's profile: who they are, their household, and account actions.
struct ProfileView: View {

    // MARK: - Properties

    @Environment(AppSession.self) private var session
    @State private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.cream.ignoresSafeArea()
                content
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { viewModel.showingEdit = true }
                        .foregroundStyle(Constants.Colors.primary)
                }
            }
            .sheet(isPresented: $viewModel.showingEdit) {
                EditProfileView(viewModel: viewModel)
            }
            .errorAlert($viewModel.errorMessage)
        }
        .task { await viewModel.load() }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: Constants.Layout.sectionSpacing) {
                header
                statsRow
                if let household = viewModel.household {
                    householdCard(household)
                }
                signOutButton
            }
            .padding(Constants.Layout.screenPadding)
        }
        .refreshable { await viewModel.load() }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 12) {
            Avatar(initials: viewModel.user.initials, colorHex: "8EBAD9", size: 96)
            VStack(spacing: 4) {
                Text(viewModel.user.name)
                    .font(Constants.Typography.title)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text(viewModel.user.email)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            if !viewModel.user.bio.isEmpty {
                Text(viewModel.user.bio)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Constants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var statsRow: some View {
        HStack(spacing: Constants.Layout.itemSpacing) {
            StatTile(title: "Member since", value: shortMonth, caption: yearString, colorHex: "9B7B58")
            StatTile(title: "Chores", value: "\(viewModel.me?.choresCompletedThisWeek ?? 0)", caption: "done this week", colorHex: "A7C7A0")
        }
    }

    private func householdCard(_ household: Household) -> some View {
        VStack(alignment: .leading, spacing: Constants.Layout.itemSpacing) {
            SectionHeader(title: "My household")
            VStack(spacing: 0) {
                infoRow(icon: "house.fill", title: household.name, subtitle: household.address)
                Divider().background(Constants.Colors.border).padding(.leading, 56)
                infoRow(icon: "person.3.fill", title: "\(household.members.count) roommates", subtitle: "Living together")
                Divider().background(Constants.Colors.border).padding(.leading, 56)
                infoRow(icon: "qrcode", title: "Invite code", subtitle: household.inviteCode)
            }
            .cardStyle(padding: 4)
        }
    }

    private func infoRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Constants.Colors.primary)
                .frame(width: 42, height: 42)
                .background(Constants.Colors.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 11, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text(subtitle)
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
    }

    private var signOutButton: some View {
        Button(role: .destructive) {
            session.signOut()
        } label: {
            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                .font(Constants.Typography.callout)
                .foregroundStyle(Constants.Colors.negative)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Constants.Colors.negative.opacity(0.1), in: RoundedRectangle(cornerRadius: Constants.Layout.controlCornerRadius, style: .continuous))
        }
        .buttonStyle(.scale)
    }

    // MARK: - Private

    private var shortMonth: String { viewModel.user.moveInDate.formatted(.dateTime.month(.abbreviated)) }
    private var yearString: String { viewModel.user.moveInDate.formatted(.dateTime.year()) }
}

#Preview {
    ProfileView()
        .environment(AppSession())
}
