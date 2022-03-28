//
//  User.swift
//  Phaze
//
//  Created by Kevin Bortas on 28/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class User {
    
    private static var totalCalories: Int = 2000
    private static var caloriesEaten: Int = 0

    private static var totalProtein: Double = 0.0
    private static var totalCarbs: Double = 0.0
    private static var totalFat: Double = 0.0
    
    // Updates the user information locally
    static func update()
    {
        caloriesEaten = 0
        caloriesEaten += Breakfast.getCalories() + Lunch.getCalories() + Dinner.getCalories() + Snacks.getCalories()

        totalProtein = 0.0
        totalCarbs = 0.0
        totalFat = 0.0

        // Calculates the total nutritional value from breakfast
        var meals = Breakfast.getMeals()
        for i in stride(from: 0, to: meals.count, by: 1) {
            print(i)
            totalProtein += meals[i].getProtein()
            totalCarbs += meals[i].getCarbs()
            totalFat += meals[i].getFat()
        }

        // Calculates the total nutritional value from lunch
        meals = Lunch.getMeals()
        for i in stride(from: 0, to: meals.count, by: 1) {
            totalProtein += meals[i].getProtein()
            totalCarbs += meals[i].getCarbs()
            totalFat += meals[i].getFat()
        }

        // Calculates the total nutritional value from dinner
        meals = Dinner.getMeals()
        for i in stride(from: 0, to: meals.count, by: 1) {
            totalProtein += meals[i].getProtein()
            totalCarbs += meals[i].getCarbs()
            totalFat += meals[i].getFat()
        }

        // Calculates the total nutritional value from snacks
        meals = Snacks.getMeals()
        for i in stride(from: 0, to: meals.count, by: 1) {
            totalProtein += meals[i].getProtein()
            totalCarbs += meals[i].getCarbs()
            totalFat += meals[i].getFat()
        }

    }

    // Update stats with information passed
    static func updateStats(cals: Int, protein: Double, carbs: Double, fat: Double)
    {
        User.caloriesEaten += cals
        User.totalProtein += protein
        User.totalCarbs += carbs
        User.totalFat += fat
    }

    // Setters and Getters
    static func getMacros() -> [Double]
    {
        return [round(totalProtein * 10.0) / 10.0, round(totalCarbs * 10.0) / 10.0, round(totalFat * 10.0) / 10.0]
    }

    static func getMacrosLabels() -> [String]
    {
        return ["Protein", "Carbohydrates", "Fat"]
    }

    static func getTotalCalories() -> Int {
        return totalCalories
    }

    static func setTotalCalories(totalCalories: Int) {
        User.totalCalories = totalCalories
    }

    static func getCaloriesEaten() -> Int {
        return caloriesEaten
    }

    static func setCaloriesEaten(caloriesEaten: Int) {
        User.caloriesEaten = caloriesEaten
    }

    static func getTotalProtein() -> Double {
        return round(totalProtein * 10.0) / 10.0
    }

    static func setTotalProtein(totalProtein: Double) {
        User.totalProtein = totalProtein
    }

    static func getTotalCarbs() -> Double {
        return round(totalCarbs * 10.0) / 10.0
    }

    static func setTotalCarbs(totalCarbs: Double) {
        User.totalCarbs = totalCarbs
    }

    static func getTotalFat() -> Double {
        return round(totalFat * 10.0) / 10.0
    }

    static func setTotalFat(totalFat: Double) {
        User.totalFat = totalFat
    }
}
