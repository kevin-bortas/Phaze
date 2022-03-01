//
//  Snacks.swift
//  Phaze
//
//  Created by Kevin Bortas on 01/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class Snacks {
    private static var meals: [Food] = []
    private static var totalCalories: Int = 0

    // Adds a meal and calculates the total calories
    static func addMeal(food: Food)
    {
        Snacks.meals.append(food)
        Snacks.totalCalories += food.getCaloriesInt()
    }

    // Returns the meals
    static func getMeals() -> [Food]
    {
        return Snacks.meals
    }

    // Returns the total calories
    static func getCalories() -> Int
    {
        return Snacks.totalCalories
    }

    static func removeMeal(position: Int)
    {
        Snacks.totalCalories -= meals[position].getCaloriesInt()
        meals.remove(at: position)
    }

    // Updates the meals with a new list of foods and overwrites the old one
    static func updateMeals(foods: [Food])
    {
        Snacks.totalCalories = 0
        Snacks.meals.removeAll()

        for food in foods {
            Snacks.addMeal(food: food)
        }
    }

    // Resets the class
    static func reset()
    {
        Snacks.totalCalories = 0
        Snacks.meals.removeAll()
    }
}
