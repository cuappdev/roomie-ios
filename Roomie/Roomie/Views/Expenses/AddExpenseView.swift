//
//  AddExpenseView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Sheet for logging a shared expense. Simple view-local form state; creation runs on the
/// passed-in `ExpensesView.ViewModel`.
struct AddExpenseView: View {

    // MARK: - Properties

    var viewModel: ExpensesView.ViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var amountText = ""
    @State private var category: Expense.Category = .groceries
    @State private var paidByID = ""
    @State private var splitAmong: Set<String> = []
    @State private var isSaving = false

    private var amount: Decimal? {
        Decimal(string: amountText.replacingOccurrences(of: ",", with: "")).flatMap { $0 > 0 ? $0 : nil }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && amount != nil && !paidByID.isEmpty && !splitAmong.isEmpty
    }

    // MARK: - UI

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense") {
                    TextField("What was it for?", text: $title)
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $category) {
                        ForEach(Expense.Category.allCases) { option in
                            Label(option.label, systemImage: option.icon).tag(option)
                        }
                    }
                }
                Section("Paid by") {
                    Picker("Paid by", selection: $paidByID) {
                        ForEach(viewModel.members) { member in
                            Text(member.name).tag(member.id)
                        }
                    }
                }
                Section("Split between") {
                    ForEach(viewModel.members) { member in
                        Button {
                            toggle(member.id)
                        } label: {
                            HStack {
                                Text(member.name)
                                    .foregroundStyle(Constants.Colors.textPrimary)
                                Spacer()
                                if splitAmong.contains(member.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Constants.Colors.primary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(!canSave || isSaving)
                }
            }
            .onAppear(perform: seedDefaults)
        }
    }

    // MARK: - Private

    private func seedDefaults() {
        if paidByID.isEmpty { paidByID = viewModel.currentUserID }
        if splitAmong.isEmpty { splitAmong = Set(viewModel.members.map(\.id)) }
    }

    private func toggle(_ id: String) {
        if splitAmong.contains(id) { splitAmong.remove(id) } else { splitAmong.insert(id) }
    }

    private func save() {
        guard let amount else { return }
        isSaving = true
        Task {
            await viewModel.add(
                title: title,
                amount: amount,
                category: category,
                paidByID: paidByID,
                splitAmong: viewModel.members.map(\.id).filter { splitAmong.contains($0) }
            )
            dismiss()
        }
    }
}

#Preview {
    AddExpenseView(viewModel: ExpensesView.ViewModel())
}
