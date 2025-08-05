//
//  Food.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation

struct Food: Identifiable, Codable {
    let id = UUID()
    let name: String
    let brand: String?
    let barcode: String?
    let nutrition: Nutrition
    let imageURL: String?
    let category: FoodCategory
    let servingSize: ServingSize
    
    enum FoodCategory: String, CaseIterable, Codable {
        case fruits = "Trái cây"
        case vegetables = "Rau củ"
        case grains = "Ngũ cốc"
        case protein = "Protein"
        case dairy = "Sản phẩm từ sữa"
        case snacks = "Đồ ăn vặt"
        case beverages = "Đồ uống"
        case other = "Khác"
    }
}

struct ServingSize: Codable {
    let amount: Double
    let unit: String // e.g., "g", "ml", "cup", "piece"
    let description: String? // e.g., "1 medium apple"
}