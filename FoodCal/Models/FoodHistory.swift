//
//  FoodHistory.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation

struct FoodEntry: Identifiable, Codable {
    let id = UUID()
    let food: Food
    let quantity: Double // multiplier for serving size
    let timestamp: Date
    let mealType: MealType
    let notes: String?
    
    enum MealType: String, CaseIterable, Codable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
    }
    
    // Calculated nutrition based on quantity
    var actualNutrition: Nutrition {
        Nutrition(
            calories: food.nutrition.calories * quantity,
            protein: food.nutrition.protein * quantity,
            carbohydrates: food.nutrition.carbohydrates * quantity,
            fat: food.nutrition.fat * quantity,
            fiber: food.nutrition.fiber.map { $0 * quantity },
            sugar: food.nutrition.sugar.map { $0 * quantity },
            sodium: food.nutrition.sodium.map { $0 * quantity },
            cholesterol: food.nutrition.cholesterol.map { $0 * quantity },
            vitamins: food.nutrition.vitamins?.mapValues { $0 * quantity },
            minerals: food.nutrition.minerals?.mapValues { $0 * quantity }
        )
    }
}

struct DailyNutritionSummary {
    let date: Date
    let entries: [FoodEntry]
    
    var totalNutrition: Nutrition {
        let totalCalories = entries.reduce(0) { $0 + $1.actualNutrition.calories }
        let totalProtein = entries.reduce(0) { $0 + $1.actualNutrition.protein }
        let totalCarbs = entries.reduce(0) { $0 + $1.actualNutrition.carbohydrates }
        let totalFat = entries.reduce(0) { $0 + $1.actualNutrition.fat }
        let totalFiber = entries.reduce(0) { $0 + ($1.actualNutrition.fiber ?? 0) }
        let totalSugar = entries.reduce(0) { $0 + ($1.actualNutrition.sugar ?? 0) }
        let totalSodium = entries.reduce(0) { $0 + ($1.actualNutrition.sodium ?? 0) }
        let totalCholesterol = entries.reduce(0) { $0 + ($1.actualNutrition.cholesterol ?? 0) }
        
        return Nutrition(
            calories: totalCalories,
            protein: totalProtein,
            carbohydrates: totalCarbs,
            fat: totalFat,
            fiber: totalFiber > 0 ? totalFiber : nil,
            sugar: totalSugar > 0 ? totalSugar : nil,
            sodium: totalSodium > 0 ? totalSodium : nil,
            cholesterol: totalCholesterol > 0 ? totalCholesterol : nil,
            vitamins: nil,
            minerals: nil
        )
    }
    
    var entriesByMeal: [FoodEntry.MealType: [FoodEntry]] {
        Dictionary(grouping: entries, by: { $0.mealType })
    }
}