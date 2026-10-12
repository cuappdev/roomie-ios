//
//  RoommateCandidate.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// A prospective roommate surfaced in the Find flow, with a compatibility score and the
/// lifestyle signals that drive it.
struct RoommateCandidate: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var age: Int
    var initials: String
    var colorHex: String
    var bio: String
    var neighborhood: String
    var budget: Int
    /// 0–100 match score against the current user's preferences.
    var compatibility: Int
    var cleanliness: Trait
    var sleepSchedule: SleepSchedule
    var socialStyle: SocialStyle
    /// Free-form lifestyle tags, e.g. "Non-smoker", "Has a cat".
    var tags: [String]

    enum Trait: String, Codable {
        case relaxed, balanced, tidy
        var label: String { rawValue.capitalized }
    }

    enum SleepSchedule: String, Codable {
        case earlyBird = "Early bird"
        case nightOwl = "Night owl"
        case flexible = "Flexible"
        var label: String { rawValue }
    }

    enum SocialStyle: String, Codable {
        case homebody = "Homebody"
        case social = "Social"
        case balanced = "Balanced"
        var label: String { rawValue }
    }

    static func == (lhs: RoommateCandidate, rhs: RoommateCandidate) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
