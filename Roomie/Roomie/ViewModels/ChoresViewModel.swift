//
//  ChoresViewModel.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import OSLog
import SwiftUI

extension ChoresView {
    @MainActor
    @Observable
    final class ViewModel {

        enum Filter: String, CaseIterable, Identifiable {
            case all = "All"
            case mine = "Mine"
            var id: String { rawValue }
        }

        // MARK: - Properties

        var state: LoadState<[Chore]> = .loading
        var members: [Roommate] = []
        var filter: Filter = .all { didSet { applyFilter() } }
        var errorMessage: String?
        var showingAdd = false

        private var allChores: [Chore] = []
        private let dataService: DataService

        init(dataService: DataService? = nil) {
            self.dataService = dataService ?? MockDataService.shared
        }

        var currentUserID: String { dataService.currentUser.id }

        /// Progress for the current filter — fraction of visible chores completed.
        var completionProgress: Double {
            let visible = visibleChores()
            guard !visible.isEmpty else { return 0 }
            return Double(visible.filter(\.isDone).count) / Double(visible.count)
        }

        // MARK: - Functions

        func load() async {
            if allChores.isEmpty { state = .loading }
            do {
                async let chores = dataService.fetchChores()
                async let household = dataService.fetchHousehold()
                allChores = try await chores
                members = try await household.members
                applyFilter()
            } catch {
                state = .error("We couldn't load the chores.")
                AppLogger.data.error("Chores load failed: \(error)")
            }
        }

        func toggle(_ chore: Chore) async {
            Haptics.shared.play(chore.isDone ? .light : .success)
            setLocally(id: chore.id, done: !chore.isDone)
            do {
                _ = try await dataService.setChore(id: chore.id, done: !chore.isDone)
            } catch {
                setLocally(id: chore.id, done: chore.isDone) // revert
                errorMessage = "Couldn't update that chore."
            }
        }

        func add(title: String, icon: String, assigneeID: String, dueDate: Date, recurrence: Chore.Recurrence) async {
            do {
                let chore = try await dataService.addChore(title: title, icon: icon, assigneeID: assigneeID, dueDate: dueDate, recurrence: recurrence)
                allChores.append(chore)
                applyFilter()
                Haptics.shared.play(.success)
            } catch {
                errorMessage = "Couldn't add that chore."
            }
        }

        func delete(_ chore: Chore) async {
            let backup = allChores
            allChores.removeAll { $0.id == chore.id }
            applyFilter()
            do {
                try await dataService.deleteChore(id: chore.id)
            } catch {
                allChores = backup
                applyFilter()
                errorMessage = "Couldn't delete that chore."
            }
        }

        // MARK: - Private

        private func visibleChores() -> [Chore] {
            switch filter {
            case .all: allChores
            case .mine: allChores.filter { $0.assigneeID == currentUserID }
            }
        }

        private func setLocally(id: String, done: Bool) {
            if let index = allChores.firstIndex(where: { $0.id == id }) {
                allChores[index].isDone = done
            }
            applyFilter()
        }

        private func applyFilter() {
            let visible = visibleChores().sorted { lhs, rhs in
                if lhs.isDone != rhs.isDone { return !lhs.isDone }
                return lhs.dueDate < rhs.dueDate
            }
            state = visible.isEmpty ? .empty : .loaded(visible)
        }
    }
}
