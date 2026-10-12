//
//  HomeViewModel.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import OSLog
import SwiftUI

extension HomeView {
    @MainActor
    @Observable
    final class ViewModel {

        /// Everything the dashboard needs, loaded together.
        struct Content {
            let household: Household
            let myChoresDue: [Chore]
            let activity: [ActivityEvent]
            let user: User
        }

        // MARK: - Properties

        var state: LoadState<Content> = .loading
        var errorMessage: String?

        private let dataService: DataService

        init(dataService: DataService? = nil) {
            self.dataService = dataService ?? MockDataService.shared
        }

        var currentUserID: String { dataService.currentUser.id }

        // MARK: - Functions

        func load() async {
            if case .loaded = state {} else { state = .loading }
            do {
                async let household = dataService.fetchHousehold()
                async let chores = dataService.fetchChores()
                async let activity = dataService.fetchActivity()
                let content = try await Content(
                    household: household,
                    myChoresDue: myChoresDue(from: chores),
                    activity: activity,
                    user: dataService.currentUser
                )
                state = .loaded(content)
            } catch {
                state = .error("We couldn't load your household. Pull to refresh.")
                AppLogger.data.error("Home load failed: \(error)")
            }
        }

        // MARK: - Private

        /// The current user's incomplete chores due today or overdue, soonest first.
        private func myChoresDue(from chores: [Chore]) -> [Chore] {
            let id = dataService.currentUser.id
            return chores
                .filter { $0.assigneeID == id && !$0.isDone }
                .filter { Calendar.current.isDateInToday($0.dueDate) || $0.dueDate.isOverdue }
                .sorted { $0.dueDate < $1.dueDate }
        }
    }
}
