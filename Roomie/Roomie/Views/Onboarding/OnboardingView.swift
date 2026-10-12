//
//  OnboardingView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The pre-auth welcome screen. Introduces Roomie's promise and routes into sign up / sign in.
struct OnboardingView: View {

    // MARK: - Properties

    @State private var path: [AuthView.ViewModel.Mode] = []

    private let highlights: [Highlight] = [
        Highlight(icon: "person.2.fill", color: "8EBAD9", title: "Find the right roommate", subtitle: "Match on budget, cleanliness, and lifestyle."),
        Highlight(icon: "checklist", color: "A7C7A0", title: "Stay organized", subtitle: "Shared chores with fair rotations and reminders."),
        Highlight(icon: "dollarsign.circle.fill", color: "F2CE6B", title: "Split expenses fairly", subtitle: "Track who paid and settle up in a tap."),
        Highlight(icon: "hand.raised.fill", color: "F0A9A0", title: "Avoid misunderstandings", subtitle: "Agree on house rules everyone signs off on.")
    ]

    // MARK: - UI

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Constants.Colors.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 32) {
                        header
                        highlightList
                        actions
                    }
                    .padding(Constants.Layout.screenPadding)
                    .padding(.top, 32)
                }
            }
            .navigationDestination(for: AuthView.ViewModel.Mode.self) { mode in
                AuthView(mode: mode)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 16) {
            RoomieLogo(size: 104)
            VStack(spacing: 6) {
                Text("Roomie")
                    .font(Constants.Typography.largeTitle)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text("Live together, better.")
                    .font(Constants.Typography.body)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
        }
    }

    private var highlightList: some View {
        VStack(spacing: Constants.Layout.itemSpacing) {
            ForEach(highlights) { highlight in
                highlightRow(highlight)
            }
        }
    }

    private func highlightRow(_ highlight: Highlight) -> some View {
        HStack(spacing: 16) {
            Image(systemName: highlight.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Color(hex: highlight.color), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(highlight.title)
                    .font(Constants.Typography.callout)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text(highlight.subtitle)
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var actions: some View {
        VStack(spacing: 12) {
            PrimaryButton(title: "Get started", icon: "arrow.right") {
                path.append(.signUp)
            }
            Button("I already have an account") {
                path.append(.signIn)
            }
            .font(Constants.Typography.callout)
            .foregroundStyle(Constants.Colors.primary)
        }
    }
}

private struct Highlight: Identifiable {
    let id = UUID()
    let icon: String
    let color: String
    let title: String
    let subtitle: String
}

#Preview {
    OnboardingView()
        .environment(AppSession())
}
