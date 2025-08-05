//
//  ProfileView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    ProfileHeaderView(user: viewModel.user)
                    
                    // Quick Stats
                    QuickStatsView(user: viewModel.user)
                    
                    // Menu Options
                    VStack(spacing: 16) {
                        ProfileMenuRow(
                            icon: "target",
                            title: LocalizedStrings.nutritionGoals,
                            subtitle: LocalizedStrings.setYourDailyTargets
                        ) {
                            viewModel.showNutritionGoals = true
                        }
                        
                        ProfileMenuRow(
                            icon: "chart.bar.fill",
                            title: LocalizedStrings.progressAndReports,
                            subtitle: LocalizedStrings.viewYourNutritionTrends
                        ) {
                            viewModel.showProgress = true
                        }
                        
                        ProfileMenuRow(
                            icon: "heart.fill",
                            title: LocalizedStrings.healthData,
                            subtitle: LocalizedStrings.syncWithAppleHealth
                        ) {
                            viewModel.showHealthData = true
                        }
                        
                        ProfileMenuRow(
                            icon: "gearshape.fill",
                            title: LocalizedStrings.settings,
                            subtitle: LocalizedStrings.appPreferencesAndPrivacy
                        ) {
                            showingSettings = true
                        }
                        
                        ProfileMenuRow(
                            icon: "questionmark.circle.fill",
                            title: LocalizedStrings.helpAndSupport,
                            subtitle: LocalizedStrings.faqsAndContactUs
                        ) {
                            viewModel.showHelp = true
                        }
                    }
                    .padding(.horizontal)
                    
                    // App Info
                    VStack(spacing: 8) {
                        Text(LocalizedStrings.foodCal)
                            .font(.headline)
                        Text(LocalizedStrings.version)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(LocalizedStrings.profile)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $viewModel.showNutritionGoals) {
                NutritionGoalsView()
                    .environmentObject(viewModel)
            }
        }
    }
}

struct ProfileHeaderView: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Image
            Circle()
                .fill(LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 100, height: 100)
                .overlay(
                    Text(user?.name.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text(user?.name ?? LocalizedStrings.user)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let email = user?.email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

struct QuickStatsView: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 16) {
            Text(LocalizedStrings.quickStats)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                StatCard(
                    title: LocalizedStrings.dailyGoal,
                    value: "\(Int(user?.nutritionGoals.dailyCalories ?? 0))",
                    unit: LocalizedStrings.cal,
                    color: .red
                )
                
                StatCard(
                    title: "BMI",
                    value: bmiString,
                    unit: "",
                    color: .blue
                )
                
                StatCard(
                    title: "TDEE",
                    value: "\(Int(user?.tdee ?? 0))",
                    unit: "cal",
                    color: .green
                )
            }
            .padding(.horizontal)
        }
    }
    
    private var bmiString: String {
        guard let user = user,
              let weight = user.weight,
              let height = user.height else {
            return "N/A"
        }
        
        let heightInMeters = height / 100
        let bmi = weight / (heightInMeters * heightInMeters)
        return String(format: "%.1f", bmi)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
}
