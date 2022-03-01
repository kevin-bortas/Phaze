//
//  Food.swift
//  Phaze
//
//  Created by Kevin Bortas on 01/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class Food {
    var name: String

    var calories: Double
    var caloriesO: Double

    var protein: Double
    var proteinO: Double

    var fat: Double
    var fatO: Double

    var carbs: Double
    var carbsO: Double

    var portionSize: Double = 1.0

    var foodInfo: [String] = []
    var measurements: [String:Int] = [:]

    var prevValue: String = "Default"
    var currentServingSize: String = "Default 100g"
    var defaultPosition: Int = 0
    var updated: Bool = false

    var servingSizeArray: [String] = []

    // Food class constructor
    init(n: String, measure: String, c: Double, p: Double, cb: Double, f: Double)
    {
        self.name = n

        self.calories = c
        self.caloriesO = c

        self.protein = p
        self.proteinO = p

        self.fat = f
        self.fatO = f

        self.carbs = cb
        self.carbsO = cb

        currentServingSize = measure

        foodInfo.append(name)
        foodInfo.append("" + String(calories))
        foodInfo.append("" + String(protein))
        foodInfo.append("" + String(fat))
        foodInfo.append("" + String(carbs))
    }

    // Food class constructor
//    func Food(String n, double c, double p, double f, double cb, Map<String, Integer> measures)
//    {
//        // Capitalises all words in the name
//        if (n.contains(" ")) {
//            String[] tmp = n.split(" ")
//            String newString = ""
//            if (tmp.length > 1) {
//                for (int i = 0 i < tmp.length i++) {
//                    newString += tmp[i].substring(0, 1).toUpperCase() + tmp[i].substring(1) + " "
//                }
//                n = newString.substring(0, newString.length() - 1)
//            }
//            setName(n)
//        } else {
//            setName(n.substring(0, 1).toUpperCase() + n.substring(1))
//        }
//
//        // Sets the current calories and original calories
//        setCalories(c)
//        setCaloriesO(c)
//
//        // Sets the current protein and original protein
//        setProtein(p)
//        setProteinO(p)
//
//        // Sets the current fat and original fat
//        setFat(f)
//        setFatO(f)
//
//        // Sets the current carbs and original carbs
//        setCarbs(cb)
//        setCarbsO(cb)
//
//        // Sets the food measurements (serving sizes)
//        setMeasurements(measures)
//        setFoodInfo()
//    }

    // Adds the food infor to a List
    func setFoodInfo()
    {
        foodInfo.append(name)
        foodInfo.append("" + String(calories))
        foodInfo.append("" + String(protein))
        foodInfo.append("" + String(fat))
        foodInfo.append("" + String(carbs))
    }

    // Setters and Getters
    func getFoodInfo() -> [String] {
        return foodInfo
    }

    func getName() -> String
    {
        return name
    }

    func setName(name: String) {
        self.name = name
    }

    func getCalories() -> Double {
        return calories
    }

    func getOriginalCalories() -> Double {
        return calories
    }

    func getCaloriesInt() -> Int
    {
        return Int(round(calories))
    }

    func setCalories(calories: Double) {
        self.calories = calories
    }

    func getProtein() -> Double {
        return protein
    }

    func setProtein(protein: Double) {
        self.protein = round(protein * 10) / 10.0
    }

    func getFat() -> Double {
        return fat
    }

    func setFat(fat: Double) {
        self.fat = round(fat * 10) / 10.0
    }

    func getCarbs() -> Double {
        return carbs
    }

    func setCarbs(carbs: Double) {
        self.carbs = round(carbs * 10) / 10.0
    }

    func getMeasurements() -> [String:Int] {
        return measurements
    }

    // Returns the Food measurements in the form of an array of Strings
    func getMeasurementsArray() -> [String] {
        var servingSize: [String] = []
        servingSize.append("Default 100")
        for key in getMeasurements().keys{
            if (key != "Default"){
                var val: Int = getMeasurements()[key]!
                servingSize.append(String(key) + " " + String(val))
            }
        }
        return servingSize
    }

    func setMeasurementsArraySorted()
    {
        servingSizeArray = getMeasurementsArray()
        for i in 0...servingSizeArray.count{
            var smallest: Int = i
            for j in i+1...servingSizeArray.count{
                var tmp: [String] = servingSizeArray[j].components(separatedBy: " ")
                
                if (Int(tmp[1])! < Int(servingSizeArray[smallest].components(separatedBy: " ")[1])!){
                    smallest = j
                }
            }
            
            var tmps: String = servingSizeArray[i]
            servingSizeArray[i] = servingSizeArray[smallest]
            servingSizeArray[smallest] = tmps
            
            if (servingSizeArray[i].components(separatedBy: " ")[0] == "Default"){
                defaultPosition = i
            }
        }
    }

    func getMeasurementsArraySorted() -> [String] {
        return servingSizeArray
    }

    // Creates a hashmap for the serving sizes
    func setMeasurements(measurements: [String:Int]) {
        self.measurements = measurements
        setMeasurementsArraySorted()
    }

    // Updates the current calories based on the serving size chosen by the user
    func updateValues(value: String)
    {
        do {
            var key: String = value.components(separatedBy: " ")[0]
            var multiplier: Double = (Double(getMeasurements()[key]!) / 100.0)

            setCalories(calories: getCaloriesO() * multiplier * portionSize)
            setProtein(protein: getProteinO() * multiplier * portionSize)
            setCarbs(carbs: getCarbsO() * multiplier * portionSize)
            setFat(fat: getFatO() * multiplier * portionSize)

            if (value != (prevValue)) {
                updated = true
                prevValue = value
                currentServingSize = value
            }
        }
        catch {
        }
    }

    // Updates the current nutritional value based on the serving inputted by the user
    // Using the calculator
    func updateValuesCalculator(value: Double)
    {
        var multiplier: Double = value / 100.0

        setCalories(calories: getCaloriesO() * multiplier * portionSize)
        setProtein(protein: getProteinO() * multiplier * portionSize)
        setCarbs(carbs: getCarbsO() * multiplier * portionSize)
        setFat(fat: getFatO() * multiplier * portionSize)
    }

    // More Setters and Getters
    func getCaloriesO() -> Double {
        return caloriesO
    }

    func setCaloriesO(caloriesO: Double) {
        self.caloriesO = caloriesO
    }

    func getProteinO() -> Double {
        return proteinO
    }

    func setProteinO(proteinO: Double) {
        self.proteinO = proteinO
    }

    func getFatO() -> Double {
        return fatO
    }

    func setFatO(fatO: Double) {
        self.fatO = fatO
    }

    func getCarbsO() -> Double {
        return carbsO
    }

    func setCarbsO(carbsO: Double) {
        self.carbsO = carbsO
    }

    // Builds a string of necessary information to send out to the database
    func buildString() -> String
    {
        let foodFormat: String = self.getName() + "%" + String(self.currentServingSize) + "%" + String(self.getCaloriesInt()) + "%" + String(self.getProtein()) + "%" + String(self.getCarbs()) + "%" + String(self.getFat()) + "|"
        return foodFormat
    }

    func getDefaultPosition() -> Int
    {
        return defaultPosition
    }

    func getDefaultPositionValue() -> String
    {
        return servingSizeArray[defaultPosition]
    }

    func setDefaultPosition(position: Int)
    {
        defaultPosition = position
    }

    func getPortionSize() -> Double {
        return portionSize
    }

    func setPortionSize(portionSize: Double) {
        self.portionSize = portionSize
    }
    
}
