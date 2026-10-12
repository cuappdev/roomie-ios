//
//  AddAgreementView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Sheet for proposing a new house agreement. View-local form state; creation runs on the
/// passed-in `AgreementsView.ViewModel`.
struct AddAgreementView: View {

    // MARK: - Properties

    var viewModel: AgreementsView.ViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var detail = ""
    @State private var category: Agreement.Category = .cleaning
    @State private var isSaving = false

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - UI

    var body: some View {
        NavigationStack {
            Form {
                Section("Agreement") {
                    TextField("e.g. Dishes done the same night", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(Agreement.Category.allCases) { option in
                            Label(option.label, systemImage: option.icon).tag(option)
                        }
                    }
                }
                Section("Details") {
                    TextField("Add any specifics everyone should know", text: $detail, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New agreement")
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
        }
    }

    // MARK: - Private

    private func save() {
        isSaving = true
        Task {
            await viewModel.add(title: title, detail: detail, category: category)
            dismiss()
        }
    }
}

#Preview {
    AddAgreementView(viewModel: AgreementsView.ViewModel())
}
