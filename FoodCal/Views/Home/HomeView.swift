//
//  HomeView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Date Picker
                    DatePicker(LocalizedStrings.selectDate, selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal)
                        .onChange(of: selectedDate) { _, newDate in
                            viewModel.loadData(for: newDate)
                        }
                    
                    // Daily Summary Card
                    DailySummaryCard(summary: viewModel.dailySummary)
                        .padding(.horizontal)
                    
                    // Nutrition Progress
                    NutritionProgressView(
                        current: viewModel.dailySummary?.totalNutrition ?? Nutrition(
                            calories: 0,
                            protein: 0,
                            carbohydrates: 0,
                            fat: 0,
                            fiber: nil,
                            sugar: nil,
                            sodium: nil,
                            cholesterol: nil,
                            vitamins: nil,
                            minerals: nil
                        ),
                        goals: viewModel.nutritionGoals
                    )
                    .padding(.horizontal)
                    
                    // Meals Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Today's Meals")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Button(LocalizedStrings.addFood) {
                                viewModel.showAddFood = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                        
                        if let summary = viewModel.dailySummary {
                            ForEach(FoodEntry.MealType.allCases, id: \.self) { mealType in
                                MealSectionView(
                                    mealType: mealType,
                                    entries: summary.entriesByMeal[mealType] ?? []
                                )
                            }
                        } else {
                            Text(LocalizedStrings.noMealsRecorded)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle(LocalizedStrings.foodCal)
            .onAppear {
                viewModel.loadData(for: selectedDate)
            }
            .sheet(isPresented: $viewModel.showAddFood) {
                AddFoodView()
                    .environmentObject(viewModel)
            }
        }
    }
}

struct DailySummaryCard: View {
    let summary: DailyNutritionSummary?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(LocalizedStrings.dailySummary)
                    .font(.headline)
                Spacer()
                Text("\(Int(summary?.totalNutrition.calories ?? 0)) \(LocalizedStrings.cal)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            if let nutrition = summary?.totalNutrition {
                HStack(spacing: 20) {
                    MacroView(title: LocalizedStrings.protein, value: nutrition.protein, unit: LocalizedStrings.grams, color: .blue)
                    MacroView(title: LocalizedStrings.carbs, value: nutrition.carbohydrates, unit: LocalizedStrings.grams, color: .green)
                    MacroView(title: LocalizedStrings.fat, value: nutrition.fat, unit: LocalizedStrings.grams, color: .orange)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MacroView: View {
    let title: String
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(Int(value))\(unit)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

struct MealSectionView: View {
    let mealType: FoodEntry.MealType
    let entries: [FoodEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mealType.rawValue)
                    .font(.headline)
                Spacer()
                Text("\(Int(entries.reduce(0) { $0 + $1.actualNutrition.calories })) cal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            if entries.isEmpty {
                Text(LocalizedStrings.noItemsAdded)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            } else {
                ForEach(entries) { entry in
                    FoodEntryRow(entry: entry)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct FoodEntryRow: View {
    let entry: FoodEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.food.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(entry.quantity, specifier: "%.1f") × \(entry.food.servingSize.description ?? "\(Int(entry.food.servingSize.amount))\(entry.food.servingSize.unit)")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\\(Int(entry.actualNutrition.calories)) \\(LocalizedStrings.cal)")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

// Placeholder for Add Food View
struct HomeAddFoodView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text(LocalizedStrings.addFoodFeature)
                    .font(.title)
                Text(LocalizedStrings.comingSoon)
                    .foregroundColor(.secondary)
            }
            .navigationTitle(LocalizedStrings.addFood)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedStrings.cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
