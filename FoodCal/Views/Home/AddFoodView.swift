//
//  AddFoodView.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import SwiftUI

struct AddFoodView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedFood: Food?
    @State private var quantity: Double = 1.0
    @State private var selectedMeal: FoodEntry.MealType = .lunch
    
    var body: some View {
        NavigationView {
            VStack {
                Text(LocalizedStrings.addFoodComingSoon)
                    .font(.title2)
                    .padding()
                
                Text(LocalizedStrings.addFoodDescription)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddFoodView()
        .environmentObject(HomeViewModel())
}