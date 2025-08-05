//
//  User.swift
//  FoodCal
//
//  Created by Tuấngg Anhhh on 30/7/25.
//

import Foundation

struct User: Codable {
    let id = UUID()
    var name: String
    var email: String?
    var dateOfBirth: Date?
    var gender: Gender?
    var height: Double? // cm
    var weight: Double? // kg
    var activityLevel: ActivityLevel
    var nutritionGoals: NutritionGoals
    var preferences: UserPreferences
    
    enum Gender: String, CaseIterable, Codable {
        case male = "Nam"
        case female = "Nữ"
        case other = "Khác"
    }
    
    enum ActivityLevel: String, CaseIterable, Codable {
        case sedentary = "Ít vận động"
        case lightlyActive = "Vận động nhẹ"
        case moderatelyActive = "Vận động vừa phải"
        case veryActive = "Vận động nhiều"
        case extraActive = "Vận động cực nhiều"
        
        var multiplier: Double {
            switch self {
            case .sedentary: return 1.2
            case .lightlyActive: return 1.375
            case .moderatelyActive: return 1.55
            case .veryActive: return 1.725
            case .extraActive: return 1.9
            }
        }
    }
    
    // Calculate BMR (Basal Metabolic Rate) using Mifflin-St Jeor Equation
    var bmr: Double? {
        guard let weight = weight, let height = height, let dateOfBirth = dateOfBirth, let gender = gender else {
            return nil
        }
        
        let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
        
        switch gender {
        case .male:
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
        case .female:
            return (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
        case .other:
            // Use average of male and female formulas
            let maleValue = (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
            let femaleValue = (10 * weight) + (6.25 * height) - (5 * Double(age)) - 161
            return (maleValue + femaleValue) / 2
        }
    }
    
    // Calculate TDEE (Total Daily Energy Expenditure)
    var tdee: Double? {
        guard let bmr = bmr else { return nil }
        return bmr * activityLevel.multiplier
    }
}

struct NutritionGoals: Codable {
    var dailyCalories: Double
    var proteinPercentage: Double // 10-35%
    var carbsPercentage: Double // 45-65%
    var fatPercentage: Double // 20-35%
    var fiberGoal: Double? // grams
    var sodiumLimit: Double? // mg
    
    static let `default` = NutritionGoals(
        dailyCalories: 2000,
        proteinPercentage: 20,
        carbsPercentage: 50,
        fatPercentage: 30,
        fiberGoal: 25,
        sodiumLimit: 2300
    )
    
    var proteinGoal: Double {
        (dailyCalories * proteinPercentage / 100) / 4 // 4 calories per gram
    }
    
    var carbsGoal: Double {
        (dailyCalories * carbsPercentage / 100) / 4 // 4 calories per gram
    }
    
    var fatGoal: Double {
        (dailyCalories * fatPercentage / 100) / 9 // 9 calories per gram
    }
}

struct UserPreferences: Codable {
    var units: UnitSystem
    var darkMode: Bool
    var notifications: NotificationSettings
    var privacy: PrivacySettings
    
    enum UnitSystem: String, CaseIterable, Codable {
        case metric = "Hệ mét"
        case imperial = "Hệ Anh"
    }
    
    static let `default` = UserPreferences(
        units: .metric,
        darkMode: false,
        notifications: NotificationSettings.default,
        privacy: PrivacySettings.default
    )
}

struct NotificationSettings: Codable {
    var mealReminders: Bool
    var goalAchievements: Bool
    var weeklyReports: Bool
    
    static let `default` = NotificationSettings(
        mealReminders: true,
        goalAchievements: true,
        weeklyReports: false
    )
}

struct PrivacySettings: Codable {
    var shareData: Bool
    var analytics: Bool
    
    static let `default` = PrivacySettings(
        shareData: false,
        analytics: true
    )
}