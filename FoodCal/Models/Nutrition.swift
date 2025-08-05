//
//  Nutrition.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation

struct Nutrition: Codable {
    let calories: Double
    let protein: Double // grams
    let carbohydrates: Double // grams
    let fat: Double // grams
    let fiber: Double? // grams
    let sugar: Double? // grams
    let sodium: Double? // mg
    let cholesterol: Double? // mg
    let vitamins: [String: Double]? // vitamin name to amount
    let minerals: [String: Double]? // mineral name to amount
    
    // Calculated properties
    var caloriesFromProtein: Double {
        protein * 4 // 4 calories per gram of protein
    }
    
    var caloriesFromCarbs: Double {
        carbohydrates * 4 // 4 calories per gram of carbs
    }
    
    var caloriesFromFat: Double {
        fat * 9 // 9 calories per gram of fat
    }
    
    // Macronutrient percentages
    var proteinPercentage: Double {
        guard calories > 0 else { return 0 }
        return (caloriesFromProtein / calories) * 100
    }
    
    var carbsPercentage: Double {
        guard calories > 0 else { return 0 }
        return (caloriesFromCarbs / calories) * 100
    }
    
    var fatPercentage: Double {
        guard calories > 0 else { return 0 }
        return (caloriesFromFat / calories) * 100
    }
}