//
//  User.swift
//  Phaze
//
//  Created by Kevin Bortas on 28/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class User {
    
    public static var url:String = "http://website4-env.eba-m9njkfbd.eu-west-1.elasticbeanstalk.com/"
    
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
        
        Breakfast.reset()
        Lunch.reset()
        Dinner.reset()
        Snacks.reset()
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
    
    // Gets the logged in user nutritional information from our database
    static func getUserNutritionalInformation(){
        
        // For each field
        let types = ["calories", "protein", "carbs", "fat", "Breakfast", "Lunch", "Dinner", "Snacks"]
        
        for type in types {
            
            // This sleep is added in because too many requests can disrupt our database and extra processes are expensive $$$
            usleep(200000)
            let newUrl = self.url + "retrieve_info"
        
            // Creates the request body
            let url = URL(string: newUrl)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "Username": self.username,
                "Type": type,
            ]
            request.httpBody = parameters.percentEncoded()

            // Sends request and gets result
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
                    
                    switch(type){
                    case "calories":
                        let calories = Int(responseString!)
                        self.setCaloriesEaten(caloriesEaten: calories!)
                        break
                    case "protein":
                        let protein = Double(responseString!)
                        self.setTotalProtein(totalProtein: protein!)
                        break
                    case "carbs":
                        let carbs = Double(responseString!)
                        self.setTotalCarbs(totalCarbs: carbs!)
                        break
                    case "fat":
                        let fat = Double(responseString!)
                        self.setTotalFat(totalFat: fat!)
                        break
                    case "Breakfast":
                        // Updates Breakfast
                        let array = responseString?.split(separator: "|")
                        var food_list:[Food] = []
                        for item in array! {
                            if (item != "None") {
                                let tokens = item.split(separator: "%")
                                let name = String(tokens[0])
                                let measure = String(tokens[1])
                                let c = tokens[2]
                                let p = tokens[3]
                                let cb = tokens[4]
                                let f = tokens[5]
                                print(name, measure)
                                let food = Food(n: name, measure: measure, c: Double(c)!, p: Double(p)!, cb: Double(cb)!, f: Double(f)!)
                                food_list.append(food)
                            }
                        }
                        Breakfast.updateMeals(foods: food_list);
                        break
                    case "Lunch":
                        // Updates Lunch
                        let array = responseString?.split(separator: "|")
                        var food_list:[Food] = []
                        for item in array! {
                            if (item != "None") {
                                let tokens = item.split(separator: "%")
                                let name = String(tokens[0])
                                let measure = String(tokens[1])
                                let c = tokens[2]
                                let p = tokens[3]
                                let cb = tokens[4]
                                let f = tokens[5]
                                print(name, measure)
                                let food = Food(n: name, measure: measure, c: Double(c)!, p: Double(p)!, cb: Double(cb)!, f: Double(f)!)
                                food_list.append(food)
                            }
                        }
                        Lunch.updateMeals(foods: food_list);
                        print("Lunch")
                        break
                    case "Dinner":
                        // Updates Dinner
                        let array = responseString?.split(separator: "|")
                        var food_list:[Food] = []
                        for item in array! {
                            if (item != "None") {
                                let tokens = item.split(separator: "%")
                                let name = String(tokens[0])
                                let measure = String(tokens[1])
                                let c = tokens[2]
                                let p = tokens[3]
                                let cb = tokens[4]
                                let f = tokens[5]
                                print(name, measure)
                                let food = Food(n: name, measure: measure, c: Double(c)!, p: Double(p)!, cb: Double(cb)!, f: Double(f)!)
                                food_list.append(food)
                            }
                        }
                        Dinner.updateMeals(foods: food_list);
                        print("Dinner")
                        break
                    case "Snacks":
                        // Updates Snacks
                        let array = responseString?.split(separator: "|")
                        var food_list:[Food] = []
                        for item in array! {
                            if (item != "None") {
                                let tokens = item.split(separator: "%")
                                let name = String(tokens[0])
                                let measure = String(tokens[1])
                                let c = tokens[2]
                                let p = tokens[3]
                                let cb = tokens[4]
                                let f = tokens[5]
                                print(name, measure)
                                let food = Food(n: name, measure: measure, c: Double(c)!, p: Double(p)!, cb: Double(cb)!, f: Double(f)!)
                                food_list.append(food)
                            }
                        }
                        Snacks.updateMeals(foods: food_list);
                        print("Snacks")
                        break
                    default:
                        break
                    }
                    
                    print("success");
                }
            }
            
            task.resume()
        }
    }
    
    // Updates the user nutritional information on our server
    static func updateServer(type:String){
        usleep(200000)
        var value:String = "";
        
        // For each field
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
        
        let newUrl = self.url + "update_micro"
    
        // Creates request body
        let url = URL(string: newUrl)!
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

        // Sends out request
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
    
    // Updates the meals that the current user ate
    static func updateMeals(){
        
        // For each meal field
        let meals = ["Breakfast", "Lunch", "Dinner", "Snacks"]
        
        for meal in meals {
            usleep(200000)
            var mealInformation:String = ""
            
            // Gets corresponding meal data
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
            
            let newUrl = self.url + "update_food"
            
            // Creates request body
            let url = URL(string: newUrl)!
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

            // Sends request
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
