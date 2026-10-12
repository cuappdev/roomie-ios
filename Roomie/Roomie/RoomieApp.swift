//
//  RoomieApp.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

@main
struct RoomieApp: App {
    @State private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            Group {
                switch session.state {
                case .loading:
                    LaunchView()
                case .onboarding:
                    OnboardingView()
                case .authenticated:
                    MainTabView()
                }
            }
            .environment(session)
            .task { await session.bootstrap() }
        }
    }
}
