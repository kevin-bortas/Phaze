//
//  Lunch.swift
//  Phaze
//
//  Created by Kevin Bortas on 01/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class Lunch {
    private static var meals: [Food] = []
    private static var totalCalories: Int = 0

    // Adds a meal and calculates the total calories
    static func addMeal(food: Food)
    {
        Lunch.meals.append(food)
        Lunch.totalCalories += food.getCaloriesInt()
    }

    // Returns the meals
    static func getMeals() -> [Food]
    {
        return Lunch.meals
    }

    // Returns the total calories
    static func getCalories() -> Int
    {
        return Lunch.totalCalories
    }

    static func removeMeal(position: Int)
    {
        Lunch.totalCalories -= meals[position].getCaloriesInt()
        meals.remove(at: position)
    }

    // Updates the meals with a new list of foods and overwrites the old one
    static func updateMeals(foods: [Food])
    {
        Lunch.totalCalories = 0
        Lunch.meals.removeAll()

        for food in foods {
            Lunch.addMeal(food: food)
        }
    }

    // Resets the class
    static func reset()
    {
        Lunch.totalCalories = 0
        Lunch.meals.removeAll()
    }
}
