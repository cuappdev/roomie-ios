//
//  Date+Formatting.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

extension Date {
    /// A short, friendly day label — "Today", "Tomorrow", "Yesterday", or e.g. "Mon, Oct 13".
    var relativeDayLabel: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return "Today" }
        if calendar.isDateInTomorrow(self) { return "Tomorrow" }
        if calendar.isDateInYesterday(self) { return "Yesterday" }
        return formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
    }

    /// Whether this date is strictly before the start of today.
    var isOverdue: Bool {
        self < Calendar.current.startOfDay(for: .now)
    }
}

extension Decimal {
    /// Formats a money amount in US dollars, e.g. `"$42.50"`.
    var currencyLabel: String {
        formatted(.currency(code: "USD"))
    }
}
