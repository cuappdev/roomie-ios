//
//  Household.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// A shared living space and the roommates in it.
struct Household: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var address: String
    /// Code roommates share to join this household.
    var inviteCode: String
    var members: [Roommate]

    static func == (lhs: Household, rhs: Household) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// A member of the current household.
struct Roommate: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var initials: String
    /// Hex color used for this roommate's avatar, so they read consistently across screens.
    var colorHex: String
    /// Whether this roommate is the signed-in user.
    var isCurrentUser: Bool
    /// Net balance in the house ledger — positive means the house owes them,
    /// negative means they owe the house.
    var balance: Decimal
    var choresCompletedThisWeek: Int

    static func == (lhs: Roommate, rhs: Roommate) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
