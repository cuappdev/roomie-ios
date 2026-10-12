//
//  Agreement.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// A shared house rule the roommates agree on — the app's way of heading off
/// misunderstandings before they happen.
struct Agreement: Codable, Identifiable, Hashable {
    let id: String
    var title: String
    var detail: String
    var category: Category
    /// IDs of roommates who have signed off on this agreement.
    var agreedBy: [String]

    enum Category: String, Codable, CaseIterable, Identifiable {
        case cleaning, quietHours, guests, sharedItems, finances, other

        var id: String { rawValue }

        var label: String {
            switch self {
            case .cleaning: "Cleaning"
            case .quietHours: "Quiet hours"
            case .guests: "Guests"
            case .sharedItems: "Shared items"
            case .finances: "Finances"
            case .other: "Other"
            }
        }

        var icon: String {
            switch self {
            case .cleaning: "sparkles"
            case .quietHours: "moon.fill"
            case .guests: "person.2.fill"
            case .sharedItems: "shippingbox.fill"
            case .finances: "dollarsign.circle.fill"
            case .other: "doc.text.fill"
            }
        }
    }

    static func == (lhs: Agreement, rhs: Agreement) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
