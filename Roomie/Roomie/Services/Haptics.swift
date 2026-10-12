//
//  Haptics.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import UIKit

/// Thin wrapper over UIKit feedback generators so views ask for tactile feedback through one
/// helper (`Haptics.shared.play(.success)`) instead of spinning up generators ad hoc.
final class Haptics {
    static let shared = Haptics()
    private init() {}

    enum Style {
        case light, medium, success, warning, selection
    }

    func play(_ style: Style) {
        switch style {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}
