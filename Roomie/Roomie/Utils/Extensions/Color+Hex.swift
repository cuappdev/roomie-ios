//
//  Color+Hex.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

extension Color {
    /// Creates a color from a 6-digit hex string (e.g. `"FBF4E8"`), with an optional opacity.
    init(hex: String, opacity: Double = 1) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var value: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&value)
        let red = Double((value & 0xFF0000) >> 16) / 255
        let green = Double((value & 0x00FF00) >> 8) / 255
        let blue = Double(value & 0x0000FF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
