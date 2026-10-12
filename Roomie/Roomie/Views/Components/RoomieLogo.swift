//
//  RoomieLogo.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The Roomie brand mark — a cozy brown tile with a smiling little house, echoing the
/// "Roomie FA26" app icon. Used on the launch and welcome screens.
struct RoomieLogo: View {
    var size: CGFloat = 120

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.26, style: .continuous)
            .fill(Constants.Colors.primary)
            .frame(width: size, height: size)
            .overlay(house)
            .shadow(color: Constants.Colors.primaryDark.opacity(0.25), radius: size * 0.12, x: 0, y: size * 0.08)
    }

    private var house: some View {
        VStack(spacing: -size * 0.04) {
            Triangle()
                .fill(Constants.Colors.primaryDark)
                .frame(width: size * 0.5, height: size * 0.26)
            RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                .fill(Constants.Colors.card)
                .frame(width: size * 0.44, height: size * 0.3)
                .overlay(face)
        }
    }

    private var face: some View {
        VStack(spacing: size * 0.03) {
            HStack(spacing: size * 0.08) {
                dot
                dot
            }
            Capsule()
                .fill(Constants.Colors.textPrimary)
                .frame(width: size * 0.12, height: size * 0.035)
        }
    }

    private var dot: some View {
        Circle()
            .fill(Constants.Colors.textPrimary)
            .frame(width: size * 0.045, height: size * 0.045)
    }
}

/// A simple upward triangle used for the house roof.
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    RoomieLogo()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.Colors.backgroundGradient)
}
