//
//  HomeViewModel.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var dailySummary: DailyNutritionSummary?
    @Published var nutritionGoals = NutritionGoals.default
    @Published var showAddFood = false
    @Published var isLoading = false
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadNutritionGoals()
    }
    
    private func setupBindings() {
        // Listen for data changes
        dataManager.$foodEntries
            .sink { [weak self] _ in
                self?.refreshCurrentData()
            }
            .store(in: &cancellables)
    }
    
    func loadData(for date: Date) {
        isLoading = true
        
        Task {
            do {
                let entries = try await dataManager.getFoodEntries(for: date)
                self.dailySummary = DailyNutritionSummary(date: date, entries: entries)
                self.isLoading = false
            } catch {
                print("Error loading data: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func refreshCurrentData() {
        guard let currentDate = dailySummary?.date else { return }
        loadData(for: currentDate)
    }
    
    private func loadNutritionGoals() {
        // Load user's nutrition goals from data manager
        if let user = dataManager.currentUser {
            nutritionGoals = user.nutritionGoals
        }
    }
    
    func addFoodEntry(_ entry: FoodEntry) {
        Task {
            do {
                try await dataManager.addFoodEntry(entry)
                showAddFood = false
            } catch {
                print("Error adding food entry: \(error)")
            }
        }
    }
    
    func deleteFoodEntry(_ entry: FoodEntry) {
        Task {
            do {
                try await dataManager.deleteFoodEntry(entry)
            } catch {
                print("Error deleting food entry: \(error)")
            }
        }
    }
}