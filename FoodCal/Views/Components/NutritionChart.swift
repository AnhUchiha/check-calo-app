//
//  NutritionChart.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct NutritionProgressView: View {
    let current: Nutrition
    let goals: NutritionGoals
    
    var body: some View {
        VStack(spacing: 16) {
            Text(LocalizedStrings.nutritionProgress)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Calories Progress
            ProgressBarView(
                title: LocalizedStrings.calories,
                current: current.calories,
                goal: goals.dailyCalories,
                unit: LocalizedStrings.cal,
                color: .red
            )
            
            // Macronutrients Progress
            HStack(spacing: 12) {
                ProgressBarView(
                    title: LocalizedStrings.protein,
                    current: current.protein,
                    goal: goals.proteinGoal,
                    unit: LocalizedStrings.grams,
                    color: .blue
                )
                
                ProgressBarView(
                    title: LocalizedStrings.carbs,
                    current: current.carbohydrates,
                    goal: goals.carbsGoal,
                    unit: LocalizedStrings.grams,
                    color: .green
                )
                
                ProgressBarView(
                    title: LocalizedStrings.fat,
                    current: current.fat,
                    goal: goals.fatGoal,
                    unit: LocalizedStrings.grams,
                    color: .orange
                )
            }
            
            // Macronutrient Pie Chart
            MacronutrientPieChart(nutrition: current)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProgressBarView: View {
    let title: String
    let current: Double
    let goal: Double
    let unit: String
    let color: Color
    
    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(current / goal, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(current))/\(Int(goal))\(unit)")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}

struct MacronutrientPieChart: View {
    let nutrition: Nutrition
    
    private var totalCalories: Double {
        max(nutrition.calories, 1) // Avoid division by zero
    }
    
    private var proteinAngle: Double {
        (nutrition.caloriesFromProtein / totalCalories) * 360
    }
    
    private var carbsAngle: Double {
        (nutrition.caloriesFromCarbs / totalCalories) * 360
    }
    
    private var fatAngle: Double {
        (nutrition.caloriesFromFat / totalCalories) * 360
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(LocalizedStrings.macronutrientBreakdown)
                .font(.subheadline)
                .fontWeight(.medium)
            
            HStack(spacing: 20) {
                // Pie Chart
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 120, height: 120)
                    
                    PieSlice(startAngle: 0, endAngle: proteinAngle)
                        .fill(.blue)
                    
                    PieSlice(startAngle: proteinAngle, endAngle: proteinAngle + carbsAngle)
                        .fill(.green)
                    
                    PieSlice(startAngle: proteinAngle + carbsAngle, endAngle: proteinAngle + carbsAngle + fatAngle)
                        .fill(.orange)
                }
                .frame(width: 120, height: 120)
                
                // Legend
                VStack(alignment: .leading, spacing: 8) {
                    LegendItem(color: .blue, title: "Protein", percentage: nutrition.proteinPercentage)
                    LegendItem(color: .green, title: "Carbs", percentage: nutrition.carbsPercentage)
                    LegendItem(color: .orange, title: "Fat", percentage: nutrition.fatPercentage)
                }
            }
        }
    }
}

struct PieSlice: Shape {
    let startAngle: Double
    let endAngle: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle - 90),
            endAngle: .degrees(endAngle - 90),
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}

struct LegendItem: View {
    let color: Color
    let title: String
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(.caption)
            
            Text("\(Int(percentage))%")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    NutritionProgressView(
        current: Nutrition(
            calories: 1500,
            protein: 75,
            carbohydrates: 200,
            fat: 50,
            fiber: 25,
            sugar: 50,
            sodium: 1200,
            cholesterol: 100,
            vitamins: nil,
            minerals: nil
        ),
        goals: NutritionGoals.default
    )
    .padding()
}