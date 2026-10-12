//
//  Constants.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Design tokens for Roomie, derived from the "Roomie FA26" Figma brand —
/// a warm cream/sand palette with a cozy brown primary and soft sticky-note accents.
enum Constants {

    // MARK: - Colors

    enum Colors {
        /// App background — warm cream.
        static let cream = Color(hex: "FBF4E8")
        /// Secondary surface / gradient base — soft sand.
        static let sand = Color(hex: "EADBC0")
        /// Elevated card surface.
        static let card = Color(hex: "FFFDF8")

        /// Brand primary — the cozy brown of the app-icon tile.
        static let primary = Color(hex: "9B7B58")
        /// Darker brown for pressed states and emphasis.
        static let primaryDark = Color(hex: "6B4F3A")

        /// Primary text — deep warm brown.
        static let textPrimary = Color(hex: "4A3728")
        /// Secondary text — muted taupe.
        static let textSecondary = Color(hex: "9A8872")
        /// Tertiary text / placeholders.
        static let textTertiary = Color(hex: "C4B59C")

        /// Hairline borders and dividers.
        static let border = Color(hex: "E7DAC4")

        // Sticky-note accents from the app icon's cards.
        static let accentBlue = Color(hex: "8EBAD9")
        static let accentYellow = Color(hex: "F2CE6B")
        static let accentPink = Color(hex: "F0A9A0")
        static let accentGreen = Color(hex: "A7C7A0")

        /// Positive balance / success.
        static let positive = Color(hex: "6FA880")
        /// Owed balance / warning.
        static let negative = Color(hex: "D98C7A")

        /// The warm top-to-bottom background gradient of the title slide.
        static let backgroundGradient = LinearGradient(
            colors: [Color(hex: "FBF2E2"), Color(hex: "EAD3AE")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Layout

    enum Layout {
        static let screenPadding: CGFloat = 20
        static let cardPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 20
        static let controlCornerRadius: CGFloat = 14
        static let sectionSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 12
        static let avatarSize: CGFloat = 44
    }

    // MARK: - Typography

    enum Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 26, weight: .bold, design: .rounded)
        static let headline = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let callout = Font.system(size: 15, weight: .medium, design: .rounded)
        static let caption = Font.system(size: 13, weight: .medium, design: .rounded)
    }
}
