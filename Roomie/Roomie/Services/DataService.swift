//
//  DataService.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// The app's data surface. ViewModels depend on this protocol, not a concrete store, so the
/// mock backing can be swapped for a `LiveDataService` (built on `NetworkManager`) later without
/// touching a single screen.
protocol DataService {
    var currentUser: User { get set }

    func fetchHousehold() async throws -> Household
    func fetchActivity() async throws -> [ActivityEvent]

    func fetchChores() async throws -> [Chore]
    func addChore(title: String, icon: String, assigneeID: String, dueDate: Date, recurrence: Chore.Recurrence) async throws -> Chore
    func setChore(id: String, done: Bool) async throws -> Chore
    func deleteChore(id: String) async throws

    func fetchExpenses() async throws -> [Expense]
    func addExpense(title: String, amount: Decimal, category: Expense.Category, paidByID: String, splitAmong: [String]) async throws -> Expense
    func settlements() async throws -> [Settlement]

    func fetchAgreements() async throws -> [Agreement]
    func toggleAgreement(id: String, for userID: String) async throws -> Agreement
    func addAgreement(title: String, detail: String, category: Agreement.Category) async throws -> Agreement

    func fetchCandidates() async throws -> [RoommateCandidate]
}
