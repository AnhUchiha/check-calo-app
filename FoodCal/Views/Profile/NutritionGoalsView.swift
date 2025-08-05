//
//  NutritionGoalsView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct NutritionGoalsView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var goals: NutritionGoals
    
    init() {
        _goals = State(initialValue: NutritionGoals.default)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(LocalizedStrings.dailyCalorieGoal) {
                    HStack {
                        Text(LocalizedStrings.calories)
                        Spacer()
                        TextField("2000", value: $goals.dailyCalories, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text(LocalizedStrings.cal)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(LocalizedStrings.macronutrientDistribution) {
                    VStack(spacing: 16) {
                        MacroSlider(
                            title: LocalizedStrings.protein,
                            percentage: $goals.proteinPercentage,
                            color: .blue,
                            range: 10...35
                        )
                        
                        MacroSlider(
                            title: LocalizedStrings.carbohydrates,
                            percentage: $goals.carbsPercentage,
                            color: .green,
                            range: 45...65
                        )
                        
                        MacroSlider(
                            title: LocalizedStrings.fat,
                            percentage: $goals.fatPercentage,
                            color: .orange,
                            range: 20...35
                        )
                    }
                    
                    Text("\\(LocalizedStrings.total): \\(Int(goals.proteinPercentage + goals.carbsPercentage + goals.fatPercentage))\\(LocalizedStrings.percent)")
                        .font(.caption)
                        .foregroundColor(abs(goals.proteinPercentage + goals.carbsPercentage + goals.fatPercentage - 100) > 1 ? .red : .secondary)
                }
                
                Section(LocalizedStrings.otherGoals) {
                    HStack {
                        Text(LocalizedStrings.fiber)
                        Spacer()
                        TextField("25", value: Binding(
                            get: { goals.fiberGoal ?? 25 },
                            set: { goals.fiberGoal = $0 }
                        ), format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        Text(LocalizedStrings.grams)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text(LocalizedStrings.sodiumLimit)
                        Spacer()
                        TextField("2300", value: Binding(
                            get: { goals.sodiumLimit ?? 2300 },
                            set: { goals.sodiumLimit = $0 }
                        ), format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        Text(LocalizedStrings.milligrams)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(LocalizedStrings.nutritionGoals)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedStrings.cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStrings.save) {
                        viewModel.updateNutritionGoals(goals)
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            goals = viewModel.user.nutritionGoals
        }
    }
}

struct MacroSlider: View {
    let title: String
    @Binding var percentage: Double
    let color: Color
    let range: ClosedRange<Double>
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(percentage))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Slider(value: $percentage, in: range, step: 1)
                .accentColor(color)
        }
    }
}

#Preview {
    NutritionGoalsView()
        .environmentObject(ProfileViewModel())
}