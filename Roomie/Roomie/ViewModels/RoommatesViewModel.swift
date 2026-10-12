//
//  RoommatesViewModel.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Observation
import SwiftUI

extension RoommatesView {
    @MainActor
    @Observable
    final class ViewModel {

        enum Segment: String, CaseIterable, Identifiable {
            case house = "My house"
            case find = "Find"
            var id: String { rawValue }
        }

        // MARK: - Properties

        var segment: Segment = .house
        var houseState: LoadState<Household> = .loading
        var findState: LoadState<[RoommateCandidate]> = .loading
        var errorMessage: String?

        private var allCandidates: [RoommateCandidate] = []
        private(set) var likedIDs: Set<String> = []
        private var passedIDs: Set<String> = []

        private let dataService: DataService

        init(dataService: DataService? = nil) {
            self.dataService = dataService ?? MockDataService.shared
        }

        var matchCount: Int { likedIDs.count }

        // MARK: - Functions

        func load() async {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.loadHouse() }
                group.addTask { await self.loadCandidates() }
            }
        }

        func loadHouse() async {
            do {
                let household = try await dataService.fetchHousehold()
                houseState = .loaded(household)
            } catch {
                houseState = .error("We couldn't load your household.")
            }
        }

        func loadCandidates() async {
            do {
                allCandidates = try await dataService.fetchCandidates()
                applyCandidateFilter()
            } catch {
                findState = .error("We couldn't load matches.")
            }
        }

        func isLiked(_ candidate: RoommateCandidate) -> Bool { likedIDs.contains(candidate.id) }

        func like(_ candidate: RoommateCandidate) {
            likedIDs.insert(candidate.id)
            Haptics.shared.play(.success)
            applyCandidateFilter()
        }

        func pass(_ candidate: RoommateCandidate) {
            passedIDs.insert(candidate.id)
            likedIDs.remove(candidate.id)
            Haptics.shared.play(.light)
            applyCandidateFilter()
        }

        // MARK: - Private

        private func applyCandidateFilter() {
            let visible = allCandidates.filter { !passedIDs.contains($0.id) }
            findState = visible.isEmpty ? .empty : .loaded(visible)
        }
    }
}
