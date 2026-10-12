//
//  LaunchView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// Shown briefly on launch while the session is restored.
struct LaunchView: View {
    var body: some View {
        ZStack {
            Constants.Colors.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 24) {
                RoomieLogo(size: 128)
                Text("Roomie")
                    .font(Constants.Typography.largeTitle)
                    .foregroundStyle(Constants.Colors.textPrimary)
                ProgressView()
                    .tint(Constants.Colors.primary)
            }
        }
    }
}

#Preview {
    LaunchView()
}
