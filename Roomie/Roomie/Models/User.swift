//
//  User.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// The signed-in person.
struct User: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var email: String
    /// Short self-description shown on the profile and to potential roommates.
    var bio: String
    /// Two-letter initials used for the avatar placeholder.
    var initials: String
    var moveInDate: Date
    /// The household this user currently belongs to, if any.
    var householdID: String?

    static func == (lhs: User, rhs: User) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
