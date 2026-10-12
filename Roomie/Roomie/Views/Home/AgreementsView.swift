//
//  AgreementsView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Shared house rules everyone signs off on — the app's way of avoiding misunderstandings
/// before they start.
struct AgreementsView: View {

    // MARK: - Properties

    @State private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        ZStack {
            Constants.Colors.cream.ignoresSafeArea()
            content
        }
        .navigationTitle("House agreements")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showingAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Constants.Colors.primary)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAdd) {
            AddAgreementView(viewModel: viewModel)
        }
        .errorAlert($viewModel.errorMessage)
        .task { await viewModel.load() }
    }

    private var content: some View {
        ScrollView {
            LoadStateView(
                state: viewModel.state,
                emptyIcon: "hand.raised",
                emptyTitle: "No agreements yet",
                emptyMessage: "Add your first house rule to get everyone aligned.",
                retry: { Task { await viewModel.load() } }
            ) { data in
                VStack(spacing: Constants.Layout.itemSpacing) {
                    intro
                    ForEach(data.agreements) { agreement in
                        AgreementRow(
                            agreement: agreement,
                            memberCount: data.memberCount,
                            hasAgreed: viewModel.hasAgreed(agreement)
                        ) {
                            Task { await viewModel.toggle(agreement) }
                        }
                    }
                }
                .padding(Constants.Layout.screenPadding)
            }
        }
        .refreshable { await viewModel.load() }
    }

    private var intro: some View {
        HStack(spacing: 10) {
            Image(systemName: "sparkles")
                .foregroundStyle(Constants.Colors.primary)
            Text("Tap “I agree” so everyone knows you're on board.")
                .font(Constants.Typography.caption)
                .foregroundStyle(Constants.Colors.textSecondary)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

#Preview {
    NavigationStack {
        AgreementsView()
    }
}
