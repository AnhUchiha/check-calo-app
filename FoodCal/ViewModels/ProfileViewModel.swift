//
//  ProfileViewModel.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoading = false
    @Published var showingEditProfile = false
    @Published var showNutritionGoals = false
    @Published var showProgress = false
    @Published var showHealthData = false
    @Published var showHelp = false
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.user = dataManager.currentUser ?? User(
            name: "User",
            email: nil,
            dateOfBirth: nil,
            gender: nil,
            height: nil,
            weight: nil,
            activityLevel: .moderatelyActive,
            nutritionGoals: .default,
            preferences: .default
        )
        
        setupBindings()
    }
    
    private func setupBindings() {
        dataManager.$currentUser
            .compactMap { $0 }
            .assign(to: \.user, on: self)
            .store(in: &cancellables)
    }
    
    func updateUser(_ updatedUser: User) {
        dataManager.updateUser(updatedUser)
    }
    
    func updateNutritionGoals(_ goals: NutritionGoals) {
        var updatedUser = user
        updatedUser.nutritionGoals = goals
        updateUser(updatedUser)
    }
    
    func updatePreferences(_ preferences: UserPreferences) {
        var updatedUser = user
        updatedUser.preferences = preferences
        updateUser(updatedUser)
    }
}