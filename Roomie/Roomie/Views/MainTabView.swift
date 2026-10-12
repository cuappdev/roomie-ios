//
//  MainTabView.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import SwiftUI

/// The signed-in app shell. Each tab owns its own `NavigationStack`, so navigation state stays
/// isolated per tab.
struct MainTabView: View {
    @State private var selection: RoomieTab = .home

    enum RoomieTab: Hashable {
        case home, chores, expenses, roommates, profile
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(RoomieTab.home)

            ChoresView()
                .tabItem { Label("Chores", systemImage: "checklist") }
                .tag(RoomieTab.chores)

            ExpensesView()
                .tabItem { Label("Expenses", systemImage: "dollarsign.circle.fill") }
                .tag(RoomieTab.expenses)

            RoommatesView()
                .tabItem { Label("Roommates", systemImage: "person.2.fill") }
                .tag(RoomieTab.roommates)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
                .tag(RoomieTab.profile)
        }
        .tint(Constants.Colors.primary)
    }
}

#Preview {
    MainTabView()
        .environment(AppSession())
}
