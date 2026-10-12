//
//  ChoresView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The shared chore list — fair rotations, due dates, and one-tap completion. Keeps the
/// household organized.
struct ChoresView: View {

    // MARK: - Properties

    @State private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.cream.ignoresSafeArea()
                content
            }
            .navigationTitle("Chores")
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
                AddChoreView(viewModel: viewModel)
            }
            .errorAlert($viewModel.errorMessage)
        }
        .task { await viewModel.load() }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: Constants.Layout.sectionSpacing) {
                progressCard
                filterPicker
                LoadStateView(
                    state: viewModel.state,
                    emptyIcon: "checklist",
                    emptyTitle: "No chores here",
                    emptyMessage: viewModel.filter == .mine ? "You have nothing assigned. Enjoy the break!" : "Add your first chore to get organized.",
                    retry: { Task { await viewModel.load() } }
                ) { chores in
                    choreList(chores)
                }
            }
            .padding(Constants.Layout.screenPadding)
        }
        .refreshable { await viewModel.load() }
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("This week")
                    .font(Constants.Typography.headline)
                    .foregroundStyle(Constants.Colors.textPrimary)
                Spacer()
                Text("\(Int(viewModel.completionProgress * 100))% done")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
            ProgressView(value: viewModel.completionProgress)
                .tint(Constants.Colors.positive)
        }
        .cardStyle()
    }

    private var filterPicker: some View {
        Picker("Filter", selection: $viewModel.filter) {
            ForEach(ViewModel.Filter.allCases) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
    }

    private func choreList(_ chores: [Chore]) -> some View {
        VStack(spacing: Constants.Layout.itemSpacing) {
            ForEach(chores) { chore in
                ChoreRow(chore: chore) {
                    Task { await viewModel.toggle(chore) }
                }
                .contextMenu {
                    Button(role: .destructive) {
                        Task { await viewModel.delete(chore) }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}

#Preview {
    ChoresView()
}
