//
//  Dinner.swift
//  Phaze
//
//  Created by Kevin Bortas on 01/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class Dinner {
    private static var meals: [Food] = []
    private static var totalCalories: Int = 0

    // Adds a meal and calculates the total calories
    static func addMeal(food: Food)
    {
        Dinner.meals.append(food)
        Dinner.totalCalories += food.getCaloriesInt()
    }

    // Returns the meals
    static func getMeals() -> [Food]
    {
        return Dinner.meals
    }

    // Returns the total calories
    static func getCalories() -> Int
    {
        return Dinner.totalCalories
    }

    static func removeMeal(position: Int)
    {
        Dinner.totalCalories -= meals[position].getCaloriesInt()
        meals.remove(at: position)
    }

    // Updates the meals with a new list of foods and overwrites the old one
    static func updateMeals(foods: [Food])
    {
        Dinner.totalCalories = 0
        Dinner.meals.removeAll()

        for food in foods {
            Dinner.addMeal(food: food)
        }
    }

    // Resets the class
    static func reset()
    {
        Dinner.totalCalories = 0
        Dinner.meals.removeAll()
    }
}
