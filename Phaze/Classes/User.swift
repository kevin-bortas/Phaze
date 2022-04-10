//
//  User.swift
//  Phaze
//
//  Created by Kevin Bortas on 28/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class User {
    
    public static var username:String = ""
    public static var password:String = ""
    
    private static var totalCalories: Int = 2000
    private static var caloriesEaten: Int = 0

    private static var totalProtein: Double = 0.0
    private static var totalCarbs: Double = 0.0
    private static var totalFat: Double = 0.0
    
    // Resets all the values of the User
    static func resetUser()
    {
        username = ""
        password = ""

        totalCalories = 2000
        caloriesEaten = 0

        totalProtein = 0.0
        totalCarbs = 0.0
        totalFat = 0.0
    }
    
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
    
    static func updateServer(type:String){
        var value:String = "";
        
        switch (type){
            case "calories":
                value = String(getCaloriesEaten())
                break
            case "protein":
                value = String(getTotalProtein())
                break
            case "carbs":
                value = String(getTotalCarbs())
                break
            case "fat":
                value = String(getTotalFat())
                break
            default:
                break
        }
    
        let url = URL(string: "http://flaskserver-env.eba-av8isidr.eu-west-1.elasticbeanstalk.com/update_micro")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "Username": self.username,
            "Value": value,
            "Type": type,
            "Action": "overwrite",
        ]
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                print("error", error ?? "Unknown error")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString)

            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            if (response.statusCode == 200){
                print("success");
            }
        }
        
        task.resume()
    }
    
    static func updateMeals(){
        
        let meals = ["Breakfast", "Lunch", "Dinner", "Snacks"]
        
        for meal in meals {
            
            var mealInformation:String = ""
            
            switch (meal){
                case "Breakfast":
                    // Builds string from meals in breakfast
                    if (Breakfast.getMeals().count > 0) {
                        for food in Breakfast.getMeals() {
                            mealInformation += food.buildString()
                        }
                    }
                    break
                case "Lunch":
                    // Builds string from meals in lunch
                    if (Lunch.getMeals().count > 0) {
                        for food in Lunch.getMeals() {
                            mealInformation += food.buildString()
                        }
                    }
                    break;
                case "Dinner":
                    // Builds string from meals in dinner
                    if (Dinner.getMeals().count > 0) {
                        for food in Dinner.getMeals() {
                            mealInformation += food.buildString()
                        }
                    }
                    break
                case "Snacks":
                    // Builds string from meals in snacks
                    if (Snacks.getMeals().count > 0) {
                        for food in Snacks.getMeals() {
                            mealInformation += food.buildString()
                        }
                    }
                    break
                default:
                    break
            }
            
            let url = URL(string: "http://flaskserver-env.eba-av8isidr.eu-west-1.elasticbeanstalk.com/update_food")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "Username": self.username,
                "Food": mealInformation,
                "Type": meal,
                "Action": "overwrite",
            ]
            request.httpBody = parameters.percentEncoded()

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {
                    print("error", error ?? "Unknown error")
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }

                let responseString = String(data: data, encoding: .utf8)
                if (response.statusCode == 200){
                    print("success");
                }
            }

            task.resume()
            
            
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
