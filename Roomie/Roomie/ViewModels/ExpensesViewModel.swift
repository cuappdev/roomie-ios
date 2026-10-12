//
//  ExpensesViewModel.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import OSLog
import SwiftUI

extension ExpensesView {
    @MainActor
    @Observable
    final class ViewModel {

        struct Content {
            let expenses: [Expense]
            let settlements: [Settlement]
            let members: [Roommate]
        }

        // MARK: - Properties

        var state: LoadState<Content> = .loading
        var errorMessage: String?
        var showingAdd = false

        private let dataService: DataService

        init(dataService: DataService? = nil) {
            self.dataService = dataService ?? MockDataService.shared
        }

        var currentUserID: String { dataService.currentUser.id }

        var members: [Roommate] {
            if case .loaded(let content) = state { return content.members }
            return []
        }

        // MARK: - Functions

        func load() async {
            if case .loaded = state {} else { state = .loading }
            do {
                async let expenses = dataService.fetchExpenses()
                async let household = dataService.fetchHousehold()
                async let settlements = dataService.settlements()
                let content = try await Content(
                    expenses: expenses,
                    settlements: settlements,
                    members: household.members
                )
                state = .loaded(content)
            } catch {
                state = .error("We couldn't load your expenses.")
                AppLogger.data.error("Expenses load failed: \(error)")
            }
        }

        func add(title: String, amount: Decimal, category: Expense.Category, paidByID: String, splitAmong: [String]) async {
            do {
                _ = try await dataService.addExpense(title: title, amount: amount, category: category, paidByID: paidByID, splitAmong: splitAmong)
                Haptics.shared.play(.success)
                await load()
            } catch {
                errorMessage = "Couldn't add that expense."
            }
        }

        /// The current user's net balance in the house ledger.
        func myBalance(from content: Content) -> Decimal {
            content.members.first { $0.id == currentUserID }?.balance ?? 0
        }

        /// Settlements that involve the current user, framed from their perspective.
        func mySettlements(from content: Content) -> [Settlement] {
            content.settlements.filter { $0.fromID == currentUserID || $0.toID == currentUserID }
        }
    }
}
