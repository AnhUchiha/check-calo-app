//
//  ScanResultView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct ScanResultView: View {
    let results: ScanResults
    @EnvironmentObject var scannerViewModel: ScannerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFood: Food?
    @State private var quantity: Double = 1.0
    @State private var selectedMeal: FoodEntry.MealType = .lunch
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Captured Image
                    if let image = results.capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Recognition Results
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStrings.detectedFoods)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        if results.detectedFoods.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.secondary)
                                Text(LocalizedStrings.noFoodDetected)
                                    .font(.headline)
                                Text(LocalizedStrings.tryTakingAnotherPhoto)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button(LocalizedStrings.searchManually) {
                                    // TODO: Implement manual search
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                        } else {
                            ForEach(results.detectedFoods, id: \.food.id) { detection in
                                FoodDetectionCard(
                                    detection: detection,
                                    isSelected: selectedFood?.id == detection.food.id
                                ) {
                                    selectedFood = detection.food
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Food Details (if selected)
                    if let food = selectedFood {
                        FoodDetailsSection(
                            food: food,
                            quantity: $quantity,
                            selectedMeal: $selectedMeal,
                            notes: $notes
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(LocalizedStrings.scanResults)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedStrings.cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStrings.addToDiary) {
                        addFoodToDiary()
                    }
                    .disabled(selectedFood == nil)
                }
            }
        }
    }
    
    private func addFoodToDiary() {
        guard let food = selectedFood else { return }
        
        let entry = FoodEntry(
            food: food,
            quantity: quantity,
            timestamp: Date(),
            mealType: selectedMeal,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Add to data manager
        Task {
            do {
                try await DataManager.shared.addFoodEntry(entry)
                dismiss()
            } catch {
                print("Error adding food entry: \(error)")
            }
        }
    }
}

struct FoodDetectionCard: View {
    let detection: FoodDetection
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(detection.food.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Confidence: \(Int(detection.confidence * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(detection.food.nutrition.calories)) cal per serving")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    ConfidenceIndicator(confidence: detection.confidence)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ConfidenceIndicator: View {
    let confidence: Double
    
    private var color: Color {
        switch confidence {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(index < Int(confidence * 5) ? color : Color(.systemGray4))
                    .frame(width: 4, height: 12)
            }
        }
    }
}

struct FoodDetailsSection: View {
    let food: Food
    @Binding var quantity: Double
    @Binding var selectedMeal: FoodEntry.MealType
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStrings.foodDetails)
                .font(.title2)
                .fontWeight(.bold)
            
            // Nutrition Info
            NutritionInfoCard(nutrition: food.nutrition, quantity: quantity)
            
            // Quantity Selector
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.quantity)
                    .font(.headline)
                
                HStack {
                    Button("-") {
                        quantity = max(0.1, quantity - 0.1)
                    }
                    .buttonStyle(.bordered)
                    
                    Text("\\(quantity, specifier: \"%.1f\") \\(LocalizedStrings.servings)")
                        .frame(minWidth: 100)
                    
                    Button("+") {
                        quantity += 0.1
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            // Meal Type Selector
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.meal)
                    .font(.headline)
                
                Picker("Meal Type", selection: $selectedMeal) {
                    ForEach(FoodEntry.MealType.allCases, id: \.self) { meal in
                        Text(meal.rawValue).tag(meal)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Notes
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.notesOptional)
                    .font(.headline)
                
                TextField(LocalizedStrings.addNotes, text: $notes, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct NutritionInfoCard: View {
    let nutrition: Nutrition
    let quantity: Double
    
    private var adjustedNutrition: Nutrition {
        Nutrition(
            calories: nutrition.calories * quantity,
            protein: nutrition.protein * quantity,
            carbohydrates: nutrition.carbohydrates * quantity,
            fat: nutrition.fat * quantity,
            fiber: nutrition.fiber.map { $0 * quantity },
            sugar: nutrition.sugar.map { $0 * quantity },
            sodium: nutrition.sodium.map { $0 * quantity },
            cholesterol: nutrition.cholesterol.map { $0 * quantity },
            vitamins: nutrition.vitamins?.mapValues { $0 * quantity },
            minerals: nutrition.minerals?.mapValues { $0 * quantity }
        )
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(LocalizedStrings.nutritionFacts)
                    .font(.headline)
                Spacer()
                Text("\\(Int(adjustedNutrition.calories)) \\(LocalizedStrings.calories)")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            HStack(spacing: 20) {
                MacroView(title: LocalizedStrings.protein, value: adjustedNutrition.protein, unit: LocalizedStrings.grams, color: .blue)
                MacroView(title: LocalizedStrings.carbs, value: adjustedNutrition.carbohydrates, unit: LocalizedStrings.grams, color: .green)
                MacroView(title: LocalizedStrings.fat, value: adjustedNutrition.fat, unit: LocalizedStrings.grams, color: .orange)
            }
            
            if let fiber = adjustedNutrition.fiber {
                HStack {
                    Text(LocalizedStrings.fiber)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(fiber))g")
                        .fontWeight(.medium)
                }
            }
            
            if let sodium = adjustedNutrition.sodium {
                HStack {
                    Text(LocalizedStrings.sodium)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(sodium))mg")
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

// Data structures for scan results
struct ScanResults: Equatable {
    let capturedImage: UIImage?
    let detectedFoods: [FoodDetection]
    
    static func == (lhs: ScanResults, rhs: ScanResults) -> Bool {
        return lhs.detectedFoods == rhs.detectedFoods
    }
}

struct FoodDetection: Equatable {
    let food: Food
    let confidence: Double
    let boundingBox: CGRect?
    
    static func == (lhs: FoodDetection, rhs: FoodDetection) -> Bool {
        return lhs.food.id == rhs.food.id && lhs.confidence == rhs.confidence
    }
}

#Preview {
    let sampleFood = Food(
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
            vitamins: nil,
            minerals: nil
        ),
        imageURL: nil,
        category: .fruits,
        servingSize: ServingSize(amount: 1, unit: "medium", description: "1 medium apple")
    )
    
    let sampleResults = ScanResults(
        capturedImage: nil,
        detectedFoods: [
            FoodDetection(food: sampleFood, confidence: 0.85, boundingBox: nil)
        ]
    )
    
    ScanResultView(results: sampleResults)
        .environmentObject(ScannerViewModel())
}