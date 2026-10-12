//
//  AgreementsViewModel.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import OSLog
import SwiftUI

extension AgreementsView {
    @MainActor
    @Observable
    final class ViewModel {

        struct Content {
            let agreements: [Agreement]
            let memberCount: Int
        }

        // MARK: - Properties

        var state: LoadState<Content> = .loading
        var errorMessage: String?
        var showingAdd = false

        private var agreements: [Agreement] = []
        private var memberCount = 0
        private let dataService: DataService

        init(dataService: DataService? = nil) {
            self.dataService = dataService ?? MockDataService.shared
        }

        var currentUserID: String { dataService.currentUser.id }

        // MARK: - Functions

        func load() async {
            if agreements.isEmpty { state = .loading }
            do {
                async let fetched = dataService.fetchAgreements()
                async let household = dataService.fetchHousehold()
                agreements = try await fetched
                memberCount = try await household.members.count
                publish()
            } catch {
                state = .error("We couldn't load your house agreements.")
                AppLogger.data.error("Agreements load failed: \(error)")
            }
        }

        func toggle(_ agreement: Agreement) async {
            Haptics.shared.play(.selection)
            do {
                let updated = try await dataService.toggleAgreement(id: agreement.id, for: currentUserID)
                if let index = agreements.firstIndex(where: { $0.id == updated.id }) {
                    agreements[index] = updated
                }
                publish()
            } catch {
                errorMessage = "Couldn't update that agreement."
            }
        }

        func add(title: String, detail: String, category: Agreement.Category) async {
            do {
                let agreement = try await dataService.addAgreement(title: title, detail: detail, category: category)
                agreements.insert(agreement, at: 0)
                publish()
                Haptics.shared.play(.success)
            } catch {
                errorMessage = "Couldn't add that agreement."
            }
        }

        func hasAgreed(_ agreement: Agreement) -> Bool {
            agreement.agreedBy.contains(currentUserID)
        }

        // MARK: - Private

        private func publish() {
            state = agreements.isEmpty ? .empty : .loaded(Content(agreements: agreements, memberCount: memberCount))
        }
    }
}
