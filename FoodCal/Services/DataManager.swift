//
//  DataManager.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation
import Combine

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var foodEntries: [FoodEntry] = []
    @Published var currentUser: User?
    
    private let userDefaults = UserDefaults.standard
    private let foodEntriesKey = "FoodEntries"
    private let currentUserKey = "CurrentUser"
    
    private init() {
        loadData()
        setupDefaultUser()
    }
    
    private func loadData() {
        loadFoodEntries()
        loadCurrentUser()
    }
    
    private func loadFoodEntries() {
        if let data = userDefaults.data(forKey: foodEntriesKey),
           let entries = try? JSONDecoder().decode([FoodEntry].self, from: data) {
            foodEntries = entries
        }
    }
    
    private func loadCurrentUser() {
        if let data = userDefaults.data(forKey: currentUserKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        }
    }
    
    private func setupDefaultUser() {
        if currentUser == nil {
            currentUser = User(
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
            saveCurrentUser()
        }
    }
    
    func addFoodEntry(_ entry: FoodEntry) async throws {
        foodEntries.append(entry)
        saveFoodEntries()
    }
    
    func deleteFoodEntry(_ entry: FoodEntry) async throws {
        foodEntries.removeAll { $0.id == entry.id }
        saveFoodEntries()
    }
    
    func getFoodEntries(for date: Date) async throws -> [FoodEntry] {
        let calendar = Calendar.current
        return foodEntries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: date)
        }
    }
    
    func updateUser(_ user: User) {
        currentUser = user
        saveCurrentUser()
    }
    
    private func saveFoodEntries() {
        if let data = try? JSONEncoder().encode(foodEntries) {
            userDefaults.set(data, forKey: foodEntriesKey)
        }
    }
    
    private func saveCurrentUser() {
        if let user = currentUser,
           let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: currentUserKey)
        }
    }
}