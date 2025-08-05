//
//  NutritionAPIService.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation

class NutritionAPIService {
    
    func searchFood(query: String) async throws -> [Food] {
        // Mock implementation - in a real app, you would call a nutrition API
        return try await withCheckedThrowingContinuation { continuation in
            // Simulate network delay
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                let mockFoods = self.generateMockFoods(for: query)
                continuation.resume(returning: mockFoods)
            }
        }
    }
    
    private func generateMockFoods(for query: String) -> [Food] {
        let mockFoods: [Food] = [
            Food(
                name: "Apple",
                brand: nil,
                barcode: nil,
                nutrition: Nutrition(
                    calories: 95,
                    protein: 0.5,
                    carbohydrates: 25,
                    fat: 0.3,
                    fiber: 4.4,
                    sugar: 19,
                    sodium: 2,
                    cholesterol: 0,
                    vitamins: ["Vitamin C": 8.4],
                    minerals: ["Potassium": 195]
                ),
                imageURL: nil,
                category: .fruits,
                servingSize: ServingSize(amount: 182, unit: "g", description: "1 medium apple")
            ),
            Food(
                name: "Banana",
                brand: nil,
                barcode: nil,
                nutrition: Nutrition(
                    calories: 105,
                    protein: 1.3,
                    carbohydrates: 27,
                    fat: 0.4,
                    fiber: 3.1,
                    sugar: 14,
                    sodium: 1,
                    cholesterol: 0,
                    vitamins: ["Vitamin C": 10.3, "Vitamin B6": 0.4],
                    minerals: ["Potassium": 422]
                ),
                imageURL: nil,
                category: .fruits,
                servingSize: ServingSize(amount: 118, unit: "g", description: "1 medium banana")
            ),
            Food(
                name: "Chicken Breast",
                brand: nil,
                barcode: nil,
                nutrition: Nutrition(
                    calories: 165,
                    protein: 31,
                    carbohydrates: 0,
                    fat: 3.6,
                    fiber: 0,
                    sugar: 0,
                    sodium: 74,
                    cholesterol: 85,
                    vitamins: ["Niacin": 14.8],
                    minerals: ["Phosphorus": 228]
                ),
                imageURL: nil,
                category: .protein,
                servingSize: ServingSize(amount: 100, unit: "g", description: "100g cooked")
            )
        ]
        
        // Return foods that match the query
        return mockFoods.filter { food in
            food.name.lowercased().contains(query.lowercased())
        }
    }
}