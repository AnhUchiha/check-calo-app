//
//  Constants.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation
import SwiftUI

struct Constants {
    
    // MARK: - Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.gray
        static let accent = Color.green
        static let background = Color(.systemBackground)
        static let cardBackground = Color(.secondarySystemBackground)
        
        // Nutrition colors
        static let protein = Color.red
        static let carbs = Color.orange
        static let fat = Color.purple
        static let calories = Color.blue
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    // MARK: - Animation
    struct Animation {
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
    }
}