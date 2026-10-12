//
//  ProfileViewModel.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import SwiftUI

extension ProfileView {
    @MainActor
    @Observable
    final class ViewModel {

        // MARK: - Properties

        var user: User
        var household: Household?
        var errorMessage: String?
        var showingEdit = false

        private var dataService: DataService

        init(dataService: DataService? = nil) {
            let service = dataService ?? MockDataService.shared
            self.dataService = service
            self.user = service.currentUser
        }

        /// The current user's membership record in the household, for their stats.
        var me: Roommate? {
            household?.members.first { $0.id == user.id }
        }

        var memberSince: String {
            user.moveInDate.formatted(.dateTime.month(.wide).year())
        }

        // MARK: - Functions

        func load() async {
            user = dataService.currentUser
            do {
                household = try await dataService.fetchHousehold()
            } catch {
                errorMessage = "We couldn't load your household details."
            }
        }

        func save(name: String, bio: String, session: AppSession) {
            var updated = user
            updated.name = name
            updated.bio = bio
            updated.initials = Self.initials(from: name)
            user = updated
            dataService.currentUser = updated
            session.currentUser = updated
            Haptics.shared.play(.success)
        }

        private static func initials(from name: String) -> String {
            let parts = name.split(separator: " ")
            return String(parts.prefix(2).compactMap(\.first)).uppercased()
        }
    }
}
