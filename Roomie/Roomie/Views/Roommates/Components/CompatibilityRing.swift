//
//  CompatibilityRing.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// A circular progress ring showing a 0–100 compatibility score.
struct CompatibilityRing: View {
    let score: Int
    var size: CGFloat = 56

    private var fraction: Double { Double(score) / 100 }

    private var tint: Color {
        switch score {
        case 85...: Constants.Colors.positive
        case 70..<85: Constants.Colors.accentYellow
        default: Constants.Colors.textSecondary
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Constants.Colors.border, lineWidth: size * 0.1)
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(tint, style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: -2) {
                Text("\(score)")
                    .font(.system(size: size * 0.32, weight: .bold, design: .rounded))
                    .foregroundStyle(Constants.Colors.textPrimary)
                Text("match")
                    .font(.system(size: size * 0.14, weight: .medium, design: .rounded))
                    .foregroundStyle(Constants.Colors.textSecondary)
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 20) {
        CompatibilityRing(score: 94)
        CompatibilityRing(score: 78)
        CompatibilityRing(score: 61, size: 72)
    }
    .padding()
    .background(Constants.Colors.cream)
}
