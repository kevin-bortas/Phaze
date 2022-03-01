//
//  Breakfast.swift
//  Phaze
//
//  Created by Kevin Bortas on 01/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class Breakfast {
    private static var meals: [Food] = []
    private static var totalCalories: Int = 0

    // Adds a meal and calculates the total calories
    static func addMeal(food: Food)
    {
        Breakfast.meals.append(food)
        Breakfast.totalCalories += food.getCaloriesInt()
    }

    // Returns the meals
    static func getMeals() -> [Food]
    {
        return Breakfast.meals
    }

    // Returns the total calories
    static func getCalories() -> Int
    {
        return Breakfast.totalCalories
    }

    static func removeMeal(position: Int)
    {
        Breakfast.totalCalories -= meals[position].getCaloriesInt()
        meals.remove(at: position)
    }

    // Updates the meals with a new list of foods and overwrites the old one
    static func updateMeals(foods: [Food])
    {
        Breakfast.totalCalories = 0
        Breakfast.meals.removeAll()

        for food in foods {
            Breakfast.addMeal(food: food)
        }
    }

    // Resets the class
    static func reset()
    {
        Breakfast.totalCalories = 0
        Breakfast.meals.removeAll()
    }
}
