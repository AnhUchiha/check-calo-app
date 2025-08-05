//
//  MLService.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation
import UIKit
import Vision

class MLService {
    
    func detectFood(in image: UIImage) async throws -> [MLDetection] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let cgImage = image.cgImage else {
                continuation.resume(throwing: MLError.invalidImage)
                return
            }
            
            // For now, we'll use a simple mock implementation
            // In a real app, you would use a trained Core ML model
            let mockDetections = generateMockDetections()
            continuation.resume(returning: mockDetections)
        }
    }
    
    private func generateMockDetections() -> [MLDetection] {
        // Mock food detection results
        let foodNames = ["Apple", "Banana", "Sandwich", "Salad", "Pizza"]
        let randomFood = foodNames.randomElement() ?? "Unknown Food"
        
        return [
            MLDetection(
                foodName: randomFood,
                confidence: Double.random(in: 0.7...0.95),
                boundingBox: CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            )
        ]
    }
}

struct MLDetection {
    let foodName: String
    let confidence: Double
    let boundingBox: CGRect
}

enum MLError: Error {
    case invalidImage
    case modelNotLoaded
    case processingFailed
}