//
//  EditProfileView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Sheet for editing name and bio. View-local form state; the save runs on the passed-in
/// `ProfileView.ViewModel`, which also syncs the app session.
struct EditProfileView: View {

    // MARK: - Properties

    var viewModel: ProfileView.ViewModel
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var bio = ""

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - UI

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Your name", text: $name)
                        .textContentType(.name)
                }
                Section("Bio") {
                    TextField("Tell your roommates a bit about you", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(name: name, bio: bio, session: session)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                name = viewModel.user.name
                bio = viewModel.user.bio
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: ProfileView.ViewModel())
        .environment(AppSession())
}
