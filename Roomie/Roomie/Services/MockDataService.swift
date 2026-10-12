//
//  MockDataService.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// In-memory implementation of `DataService` that seeds a realistic household and simulates
/// network latency. This is the app's data source until the live REST API lands.
final class MockDataService: DataService {
    static let shared = MockDataService()
    private init() {}

    // MARK: - Identity

    static let currentUserID = "u1"

    var currentUser = User(
        id: currentUserID,
        name: "Mina Liu",
        email: "mina@roomie.app",
        bio: "Grad student, early riser, loves a tidy kitchen and Sunday meal prep. ☕️",
        initials: "ML",
        moveInDate: Calendar.current.date(byAdding: .month, value: -8, to: .now) ?? .now,
        householdID: "h1"
    )

    // MARK: - Store

    private lazy var members: [Roommate] = [
        Roommate(id: "u1", name: "Mina Liu", initials: "ML", colorHex: "8EBAD9", isCurrentUser: true, balance: 0, choresCompletedThisWeek: 4),
        Roommate(id: "u2", name: "Leah Kim", initials: "LK", colorHex: "F0A9A0", isCurrentUser: false, balance: 0, choresCompletedThisWeek: 3),
        Roommate(id: "u3", name: "Sam Rivera", initials: "SR", colorHex: "A7C7A0", isCurrentUser: false, balance: 0, choresCompletedThisWeek: 2),
        Roommate(id: "u4", name: "Alex Chen", initials: "AC", colorHex: "F2CE6B", isCurrentUser: false, balance: 0, choresCompletedThisWeek: 5)
    ]

    private var allMemberIDs: [String] { members.map(\.id) }

    private lazy var chores: [Chore] = {
        let cal = Calendar.current
        func day(_ offset: Int) -> Date { cal.date(byAdding: .day, value: offset, to: cal.startOfDay(for: .now)) ?? .now }
        return [
            Chore(id: "c1", title: "Take out trash & recycling", icon: "trash.fill", assigneeID: "u1", assigneeName: "Mina Liu", dueDate: day(0), recurrence: .weekly, isDone: false),
            Chore(id: "c2", title: "Clean the bathroom", icon: "shower.fill", assigneeID: "u2", assigneeName: "Leah Kim", dueDate: day(1), recurrence: .weekly, isDone: false),
            Chore(id: "c3", title: "Do the dishes", icon: "dishwasher.fill", assigneeID: "u3", assigneeName: "Sam Rivera", dueDate: day(0), recurrence: .daily, isDone: false),
            Chore(id: "c4", title: "Vacuum living room", icon: "wind", assigneeID: "u4", assigneeName: "Alex Chen", dueDate: day(2), recurrence: .weekly, isDone: false),
            Chore(id: "c5", title: "Water the plants", icon: "leaf.fill", assigneeID: "u1", assigneeName: "Mina Liu", dueDate: day(-1), recurrence: .weekly, isDone: false),
            Chore(id: "c6", title: "Wipe kitchen counters", icon: "bubbles.and.sparkles.fill", assigneeID: "u2", assigneeName: "Leah Kim", dueDate: day(-2), recurrence: .daily, isDone: true),
            Chore(id: "c7", title: "Restock paper towels", icon: "cart.fill", assigneeID: "u3", assigneeName: "Sam Rivera", dueDate: day(4), recurrence: .monthly, isDone: false)
        ]
    }()

    private lazy var expenses: [Expense] = {
        let cal = Calendar.current
        func day(_ offset: Int) -> Date { cal.date(byAdding: .day, value: offset, to: .now) ?? .now }
        return [
            Expense(id: "e1", title: "October rent", amount: 3200, paidByID: "u1", paidByName: "Mina Liu", date: day(-9), category: .rent, splitAmong: allMemberIDs),
            Expense(id: "e2", title: "Electricity bill", amount: 142.40, paidByID: "u2", paidByName: "Leah Kim", date: day(-6), category: .utilities, splitAmong: allMemberIDs),
            Expense(id: "e3", title: "Costco grocery run", amount: 188.20, paidByID: "u3", paidByName: "Sam Rivera", date: day(-4), category: .groceries, splitAmong: allMemberIDs),
            Expense(id: "e4", title: "Wifi — October", amount: 69.99, paidByID: "u4", paidByName: "Alex Chen", date: day(-3), category: .utilities, splitAmong: allMemberIDs),
            Expense(id: "e5", title: "Dish soap & sponges", amount: 24.75, paidByID: "u1", paidByName: "Mina Liu", date: day(-1), category: .household, splitAmong: allMemberIDs),
            Expense(id: "e6", title: "Pizza night 🍕", amount: 52.00, paidByID: "u2", paidByName: "Leah Kim", date: day(0), category: .food, splitAmong: ["u1", "u2", "u4"])
        ]
    }()

    private lazy var agreements: [Agreement] = [
        Agreement(id: "a1", title: "Quiet hours after 11pm on weeknights", detail: "Keep music and calls low-volume Sunday–Thursday after 11pm so everyone can rest before class and work.", category: .quietHours, agreedBy: ["u1", "u2", "u3", "u4"]),
        Agreement(id: "a2", title: "Dishes done the same night", detail: "No dishes left in the sink overnight — wash or load the dishwasher before bed.", category: .cleaning, agreedBy: ["u1", "u2", "u3"]),
        Agreement(id: "a3", title: "Give a heads-up for overnight guests", detail: "Text the house group chat before a guest stays over, especially on weeknights.", category: .guests, agreedBy: ["u1", "u3"]),
        Agreement(id: "a4", title: "Shared groceries go on the house ledger", detail: "Milk, paper towels, dish soap and other shared staples get split; label personal food.", category: .finances, agreedBy: ["u1", "u2", "u4"]),
        Agreement(id: "a5", title: "Label and share the fridge shelves", detail: "Top two shelves shared, bottom shelf personal. Clear out leftovers after 5 days.", category: .sharedItems, agreedBy: ["u2"])
    ]

    private lazy var candidates: [RoommateCandidate] = [
        RoommateCandidate(id: "rc1", name: "Priya Nair", age: 24, initials: "PN", colorHex: "8EBAD9", bio: "PhD student in CS. Quiet weekdays, brunch person on weekends. Looking for a clean, calm place.", neighborhood: "Collegetown", budget: 900, compatibility: 94, cleanliness: .tidy, sleepSchedule: .earlyBird, socialStyle: .balanced, tags: ["Non-smoker", "Has a cat", "Vegetarian"]),
        RoommateCandidate(id: "rc2", name: "Jordan Blake", age: 26, initials: "JB", colorHex: "A7C7A0", bio: "Software engineer, remote. Big on cooking and keeping common areas spotless.", neighborhood: "Fall Creek", budget: 1050, compatibility: 88, cleanliness: .tidy, sleepSchedule: .flexible, socialStyle: .homebody, tags: ["Non-smoker", "Cooks a lot", "Pet-friendly"]),
        RoommateCandidate(id: "rc3", name: "Dani Flores", age: 23, initials: "DF", colorHex: "F2CE6B", bio: "Design MFA. Night owl, headphones on, super low-drama. Loves plants.", neighborhood: "Collegetown", budget: 850, compatibility: 81, cleanliness: .balanced, sleepSchedule: .nightOwl, socialStyle: .social, tags: ["Non-smoker", "Plant parent"]),
        RoommateCandidate(id: "rc4", name: "Marcus Webb", age: 27, initials: "MW", colorHex: "F0A9A0", bio: "Med student. Early mornings, gym rat, keeps to a schedule. Tidy and reliable.", neighborhood: "East Hill", budget: 1100, compatibility: 76, cleanliness: .tidy, sleepSchedule: .earlyBird, socialStyle: .homebody, tags: ["Non-smoker", "Early riser"]),
        RoommateCandidate(id: "rc5", name: "Ivy Zhang", age: 25, initials: "IZ", colorHex: "C8A2C8", bio: "Grad TA in math. Friendly, loves board-game nights but respects quiet study time.", neighborhood: "Collegetown", budget: 950, compatibility: 90, cleanliness: .balanced, sleepSchedule: .flexible, socialStyle: .social, tags: ["Non-smoker", "Board games", "Coffee snob"])
    ]

    // MARK: - Household & activity

    func fetchHousehold() async throws -> Household {
        try await simulateLatency()
        let balances = computeNetBalances()
        let updated = members.map { member -> Roommate in
            var copy = member
            copy.balance = balances[member.id] ?? 0
            return copy
        }
        members = updated
        return Household(
            id: "h1",
            name: "Collegetown House",
            address: "412 College Ave, Ithaca, NY",
            inviteCode: "ROOMIE-4F2A",
            members: updated
        )
    }

    func fetchActivity() async throws -> [ActivityEvent] {
        try await simulateLatency()
        let cal = Calendar.current
        func ago(_ h: Int) -> Date { cal.date(byAdding: .hour, value: -h, to: .now) ?? .now }
        return [
            ActivityEvent(id: "ac1", actorName: "Leah Kim", actorInitials: "LK", actorColorHex: "F0A9A0", kind: .expense, summary: "added “Pizza night 🍕” — $52.00", timestamp: ago(2)),
            ActivityEvent(id: "ac2", actorName: "Leah Kim", actorInitials: "LK", actorColorHex: "F0A9A0", kind: .chore, summary: "completed “Wipe kitchen counters”", timestamp: ago(6)),
            ActivityEvent(id: "ac3", actorName: "Alex Chen", actorInitials: "AC", actorColorHex: "F2CE6B", kind: .expense, summary: "added “Wifi — October” — $69.99", timestamp: ago(28)),
            ActivityEvent(id: "ac4", actorName: "Mina Liu", actorInitials: "ML", actorColorHex: "8EBAD9", kind: .agreement, summary: "agreed to “Quiet hours after 11pm”", timestamp: ago(40)),
            ActivityEvent(id: "ac5", actorName: "Sam Rivera", actorInitials: "SR", actorColorHex: "A7C7A0", kind: .expense, summary: "added “Costco grocery run” — $188.20", timestamp: ago(52))
        ]
    }

    // MARK: - Chores

    func fetchChores() async throws -> [Chore] {
        try await simulateLatency()
        return chores.sorted { lhs, rhs in
            if lhs.isDone != rhs.isDone { return !lhs.isDone }
            return lhs.dueDate < rhs.dueDate
        }
    }

    func addChore(title: String, icon: String, assigneeID: String, dueDate: Date, recurrence: Chore.Recurrence) async throws -> Chore {
        try await simulateLatency()
        let name = members.first { $0.id == assigneeID }?.name ?? "Unassigned"
        let chore = Chore(id: UUID().uuidString, title: title, icon: icon, assigneeID: assigneeID, assigneeName: name, dueDate: dueDate, recurrence: recurrence, isDone: false)
        chores.append(chore)
        return chore
    }

    func setChore(id: String, done: Bool) async throws -> Chore {
        guard let index = chores.firstIndex(where: { $0.id == id }) else { throw DataError.notFound }
        chores[index].isDone = done
        return chores[index]
    }

    func deleteChore(id: String) async throws {
        chores.removeAll { $0.id == id }
    }

    // MARK: - Expenses

    func fetchExpenses() async throws -> [Expense] {
        try await simulateLatency()
        return expenses.sorted { $0.date > $1.date }
    }

    func addExpense(title: String, amount: Decimal, category: Expense.Category, paidByID: String, splitAmong: [String]) async throws -> Expense {
        try await simulateLatency()
        let name = members.first { $0.id == paidByID }?.name ?? "Someone"
        let expense = Expense(id: UUID().uuidString, title: title, amount: amount, paidByID: paidByID, paidByName: name, date: .now, category: category, splitAmong: splitAmong)
        expenses.append(expense)
        return expense
    }

    func settlements() async throws -> [Settlement] {
        try await simulateLatency()
        return computeSettlements()
    }

    // MARK: - Agreements

    func fetchAgreements() async throws -> [Agreement] {
        try await simulateLatency()
        return agreements
    }

    func toggleAgreement(id: String, for userID: String) async throws -> Agreement {
        guard let index = agreements.firstIndex(where: { $0.id == id }) else { throw DataError.notFound }
        if agreements[index].agreedBy.contains(userID) {
            agreements[index].agreedBy.removeAll { $0 == userID }
        } else {
            agreements[index].agreedBy.append(userID)
        }
        return agreements[index]
    }

    func addAgreement(title: String, detail: String, category: Agreement.Category) async throws -> Agreement {
        try await simulateLatency()
        let agreement = Agreement(id: UUID().uuidString, title: title, detail: detail, category: category, agreedBy: [MockDataService.currentUserID])
        agreements.insert(agreement, at: 0)
        return agreement
    }

    // MARK: - Find

    func fetchCandidates() async throws -> [RoommateCandidate] {
        try await simulateLatency()
        return candidates.sorted { $0.compatibility > $1.compatibility }
    }

    // MARK: - Private

    /// Net house-ledger balance per member: what they've paid minus their share of everything.
    private func computeNetBalances() -> [String: Decimal] {
        var net: [String: Decimal] = [:]
        for member in members { net[member.id] = 0 }
        for expense in expenses {
            net[expense.paidByID, default: 0] += expense.amount
            let share = expense.shareEach
            for memberID in expense.splitAmong {
                net[memberID, default: 0] -= share
            }
        }
        return net
    }

    /// Greedy "who owes whom" minimization over the net balances.
    private func computeSettlements() -> [Settlement] {
        let net = computeNetBalances()
        func name(_ id: String) -> String { members.first { $0.id == id }?.name ?? "—" }

        var creditors = net.filter { $0.value > 0 }.map { (id: $0.key, amount: $0.value) }.sorted { $0.amount > $1.amount }
        var debtors = net.filter { $0.value < 0 }.map { (id: $0.key, amount: -$0.value) }.sorted { $0.amount > $1.amount }

        var result: [Settlement] = []
        var i = 0, j = 0
        while i < debtors.count, j < creditors.count {
            let pay = min(debtors[i].amount, creditors[j].amount)
            if pay > 0.001 {
                result.append(Settlement(
                    fromID: debtors[i].id, fromName: name(debtors[i].id),
                    toID: creditors[j].id, toName: name(creditors[j].id),
                    amount: pay
                ))
            }
            debtors[i].amount -= pay
            creditors[j].amount -= pay
            if debtors[i].amount <= 0.001 { i += 1 }
            if creditors[j].amount <= 0.001 { j += 1 }
        }
        return result
    }

    private func simulateLatency() async throws {
        try? await Task.sleep(for: .milliseconds(450))
    }
}

enum DataError: LocalizedError {
    case notFound
    var errorDescription: String? { "We couldn't find that item." }
}
