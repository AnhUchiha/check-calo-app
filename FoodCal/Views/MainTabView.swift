//
//  MainTabView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(homeViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(LocalizedStrings.home)
                }
            
            CameraScannerView()
                .environmentObject(scannerViewModel)
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text(LocalizedStrings.scanner)
                }
            
            ProfileView()
                .environmentObject(profileViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(LocalizedStrings.profile)
                }
        }
        .accentColor(.primary)
    }
}

#Preview {
    MainTabView()
}