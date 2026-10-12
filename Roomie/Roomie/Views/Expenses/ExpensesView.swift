//
//  ExpensesView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Shared expenses and balances — who paid, who owes whom, and how to settle up. Keeps money
/// from becoming a misunderstanding.
struct ExpensesView: View {

    // MARK: - Properties

    @State private var viewModel = ViewModel()

    // MARK: - UI

    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.cream.ignoresSafeArea()
                content
            }
            .navigationTitle("Expenses")
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
                AddExpenseView(viewModel: viewModel)
            }
            .errorAlert($viewModel.errorMessage)
        }
        .task { await viewModel.load() }
    }

    private var content: some View {
        ScrollView {
            LoadStateView(
                state: viewModel.state,
                emptyIcon: "dollarsign.circle",
                emptyTitle: "No expenses yet",
                emptyMessage: "Add a shared cost to start tracking balances.",
                retry: { Task { await viewModel.load() } }
            ) { data in
                VStack(spacing: Constants.Layout.sectionSpacing) {
                    balanceCard(data)
                    settleUp(data)
                    expenseList(data)
                }
                .padding(Constants.Layout.screenPadding)
            }
        }
        .refreshable { await viewModel.load() }
    }

    // MARK: - Sections

    private func balanceCard(_ data: ViewModel.Content) -> some View {
        let balance = viewModel.myBalance(from: data)
        let isOwed = balance >= 0
        return VStack(spacing: 6) {
            Text(isOwed ? "You're owed overall" : "You owe overall")
                .font(Constants.Typography.caption)
                .foregroundStyle(.white.opacity(0.85))
            Text(abs(balance).currencyLabel)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            LinearGradient(colors: [Constants.Colors.primary, Constants.Colors.primaryDark],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius, style: .continuous))
    }

    @ViewBuilder
    private func settleUp(_ data: ViewModel.Content) -> some View {
        let settlements = viewModel.mySettlements(from: data)
        VStack(alignment: .leading, spacing: Constants.Layout.itemSpacing) {
            SectionHeader(title: "Settle up")
            if settlements.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Constants.Colors.positive)
                    Text("You're all settled up. 🎉")
                        .font(Constants.Typography.body)
                        .foregroundStyle(Constants.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle()
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(settlements.enumerated()), id: \.element.id) { index, settlement in
                        SettlementRow(settlement: settlement, currentUserID: viewModel.currentUserID)
                        if index < settlements.count - 1 {
                            Divider().background(Constants.Colors.border)
                        }
                    }
                }
                .cardStyle(padding: 4)
            }
        }
    }

    private func expenseList(_ data: ViewModel.Content) -> some View {
        VStack(alignment: .leading, spacing: Constants.Layout.itemSpacing) {
            SectionHeader(title: "Recent expenses")
            ForEach(data.expenses) { expense in
                ExpenseRow(expense: expense, currentUserID: viewModel.currentUserID)
            }
        }
    }
}

#Preview {
    ExpensesView()
}
