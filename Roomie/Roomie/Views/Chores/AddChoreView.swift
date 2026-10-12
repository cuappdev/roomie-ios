//
//  AddChoreView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Sheet for adding a chore. Holds only simple view-local form state; the actual creation runs
/// on the passed-in `ChoresView.ViewModel`.
struct AddChoreView: View {

    // MARK: - Properties

    var viewModel: ChoresView.ViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var icon = "sparkles"
    @State private var assigneeID = ""
    @State private var dueDate = Date.now
    @State private var recurrence: Chore.Recurrence = .weekly
    @State private var isSaving = false

    private let icons = ["sparkles", "trash.fill", "dishwasher.fill", "shower.fill", "wind", "leaf.fill", "bubbles.and.sparkles.fill", "cart.fill", "washer.fill", "bed.double.fill"]

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !assigneeID.isEmpty
    }

    // MARK: - UI

    var body: some View {
        NavigationStack {
            Form {
                Section("Chore") {
                    TextField("What needs doing?", text: $title)
                    iconPicker
                }
                Section("Assign to") {
                    Picker("Roommate", selection: $assigneeID) {
                        ForEach(viewModel.members) { member in
                            Text(member.name).tag(member.id)
                        }
                    }
                }
                Section("Schedule") {
                    DatePicker("Due", selection: $dueDate, displayedComponents: .date)
                    Picker("Repeats", selection: $recurrence) {
                        ForEach(Chore.Recurrence.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                }
            }
            .navigationTitle("New chore")
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
            .onAppear {
                if assigneeID.isEmpty {
                    assigneeID = viewModel.currentUserID
                }
            }
        }
    }

    private var iconPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(icons, id: \.self) { symbol in
                    Button {
                        icon = symbol
                    } label: {
                        Image(systemName: symbol)
                            .font(.system(size: 18))
                            .foregroundStyle(icon == symbol ? .white : Constants.Colors.primary)
                            .frame(width: 44, height: 44)
                            .background(
                                (icon == symbol ? Constants.Colors.primary : Constants.Colors.primary.opacity(0.1)),
                                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                            )
                    }
                    .buttonStyle(.scale)
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Private

    private func save() {
        isSaving = true
        Task {
            await viewModel.add(title: title, icon: icon, assigneeID: assigneeID, dueDate: dueDate, recurrence: recurrence)
            dismiss()
        }
    }
}

#Preview {
    AddChoreView(viewModel: ChoresView.ViewModel())
}
