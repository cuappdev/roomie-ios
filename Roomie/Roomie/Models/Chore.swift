//
//  Chore.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// A task in the household's shared chore list.
struct Chore: Codable, Identifiable, Hashable {
    let id: String
    var title: String
    /// SF Symbol name representing the chore.
    var icon: String
    var assigneeID: String
    var assigneeName: String
    var dueDate: Date
    var recurrence: Recurrence
    var isDone: Bool

    enum Recurrence: String, Codable, CaseIterable, Identifiable {
        case once, daily, weekly, monthly

        var id: String { rawValue }

        var label: String {
            switch self {
            case .once: "One-time"
            case .daily: "Daily"
            case .weekly: "Weekly"
            case .monthly: "Monthly"
            }
        }
    }

    static func == (lhs: Chore, rhs: Chore) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
