//
//  Expense.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// A shared cost paid by one roommate and split among several.
struct Expense: Codable, Identifiable, Hashable {
    let id: String
    var title: String
    var amount: Decimal
    var paidByID: String
    var paidByName: String
    var date: Date
    var category: Category
    /// IDs of the roommates this expense is split evenly among.
    var splitAmong: [String]

    /// Each person's even share of this expense.
    var shareEach: Decimal {
        guard !splitAmong.isEmpty else { return 0 }
        return amount / Decimal(splitAmong.count)
    }

    enum Category: String, Codable, CaseIterable, Identifiable {
        case rent, utilities, groceries, household, food, other

        var id: String { rawValue }

        var label: String { rawValue.capitalized }

        var icon: String {
            switch self {
            case .rent: "house.fill"
            case .utilities: "bolt.fill"
            case .groceries: "cart.fill"
            case .household: "bubbles.and.sparkles.fill"
            case .food: "fork.knife"
            case .other: "ellipsis.circle.fill"
            }
        }

        var colorHex: String {
            switch self {
            case .rent: "8EBAD9"
            case .utilities: "F2CE6B"
            case .groceries: "A7C7A0"
            case .household: "F0A9A0"
            case .food: "D9A679"
            case .other: "B5A48C"
            }
        }
    }

    static func == (lhs: Expense, rhs: Expense) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// A simplified "who owes whom" settlement line between two roommates.
struct Settlement: Identifiable, Hashable {
    var id: String { "\(fromID)->\(toID)" }
    let fromID: String
    let fromName: String
    let toID: String
    let toName: String
    let amount: Decimal
}
