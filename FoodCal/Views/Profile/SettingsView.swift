//
//  SettingsView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(LocalizedStrings.units) {
                    Picker(LocalizedStrings.unitSystem, selection: Binding(
                        get: { viewModel.user.preferences.units },
                        set: { newValue in
                            var updatedUser = viewModel.user
                            updatedUser.preferences.units = newValue
                            viewModel.updateUser(updatedUser)
                        }
                    )) {
                        ForEach(UserPreferences.UnitSystem.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(LocalizedStrings.appearance) {
                    Toggle(LocalizedStrings.darkMode, isOn: Binding(
                        get: { viewModel.user.preferences.darkMode },
                        set: { newValue in
                            var updatedUser = viewModel.user
                            updatedUser.preferences.darkMode = newValue
                            viewModel.updateUser(updatedUser)
                        }
                    ))
                }
                
                Section(LocalizedStrings.notifications) {
                    Toggle(LocalizedStrings.mealReminders, isOn: Binding(
                        get: { viewModel.user.preferences.notifications.mealReminders },
                        set: { newValue in
                            var updatedUser = viewModel.user
                            updatedUser.preferences.notifications.mealReminders = newValue
                            viewModel.updateUser(updatedUser)
                        }
                    ))
                    
                    Toggle(LocalizedStrings.goalAchievements, isOn: Binding(
                        get: { viewModel.user.preferences.notifications.goalAchievements },
                        set: { newValue in
                            var updatedUser = viewModel.user
                            updatedUser.preferences.notifications.goalAchievements = newValue
                            viewModel.updateUser(updatedUser)
                        }
                    ))
                    
                    Toggle(LocalizedStrings.weeklyReports, isOn: Binding(
                        get: { viewModel.user.preferences.notifications.weeklyReports },
                        set: { newValue in
                            var updatedUser = viewModel.user
                            updatedUser.preferences.notifications.weeklyReports = newValue
                            viewModel.updateUser(updatedUser)
                        }
                    ))
                }
                
                Section(LocalizedStrings.privacy) {
                    Toggle(LocalizedStrings.shareData, isOn: Binding(
                        get: { viewModel.user.preferences.privacy.shareData },
                        set: { newValue in
                            var updatedUser = viewModel.user
                            updatedUser.preferences.privacy.shareData = newValue
                            viewModel.updateUser(updatedUser)
                        }
                    ))
                    
                    Toggle(LocalizedStrings.analytics, isOn: Binding(
                        get: { viewModel.user.preferences.privacy.analytics },
                        set: { newValue in
                            var updatedUser = viewModel.user
                            updatedUser.preferences.privacy.analytics = newValue
                            viewModel.updateUser(updatedUser)
                        }
                    ))
                }
            }
            .navigationTitle(LocalizedStrings.settings)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStrings.done) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ProfileViewModel())
}