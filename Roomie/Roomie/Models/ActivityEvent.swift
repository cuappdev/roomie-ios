//
//  ActivityEvent.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// A single entry in the household's recent-activity feed on the Home screen.
struct ActivityEvent: Codable, Identifiable, Hashable {
    let id: String
    var actorName: String
    var actorInitials: String
    var actorColorHex: String
    var kind: Kind
    var summary: String
    var timestamp: Date

    enum Kind: String, Codable {
        case chore, expense, agreement, member

        var icon: String {
            switch self {
            case .chore: "checkmark.circle.fill"
            case .expense: "dollarsign.circle.fill"
            case .agreement: "hand.raised.fill"
            case .member: "person.fill.badge.plus"
            }
        }
    }

    static func == (lhs: ActivityEvent, rhs: ActivityEvent) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
