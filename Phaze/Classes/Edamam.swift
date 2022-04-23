//
//  Edamam.swift
//  Phaze
//
//  Created by Kevin Bortas on 03/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation

class Edamam {
    
    // Our API keys
    let food_appid: String
    let food_appkey: String
    
    init(){
        self.food_appid = "f635a9ab"
        self.food_appkey = "fee3c57a8a37a553efef8356f775f5c3"
    }
    
    // Queries the Food Database API (Edamam) with our predicted food or barcode and returns its nutritional information
    func get(query: String) async -> [String:AnyObject] {
        
        // Pre-processes the food string before passing it in the url
        let splitQuery = query.lowercased().split(separator: "_")
        var constructedQuery: String = ""
        print(splitQuery)
        if (splitQuery.count > 1){
            constructedQuery = splitQuery.joined(separator: "%20")
        }
        else {
            constructedQuery = splitQuery.joined(separator: "")
        }
        
        let splitQuery2 = constructedQuery.lowercased().split(separator: " ")
        if (splitQuery2.count > 1){
            constructedQuery = splitQuery2.joined(separator: "%20")
        }
        else {
            constructedQuery = splitQuery2.joined(separator: "")
        }
        
        if (constructedQuery.last == " "){
            constructedQuery.dropLast()
        }
        
        let requestString = "https://api.edamam.com/api/food-database/v2/parser?app_id=f635a9ab&app_key=fee3c57a8a37a553efef8356f775f5c3&nutrition-type=cooking&" + constructedQuery
        
        let url = URL(string: requestString)
        
        // Starts a new task -> queries database -> returns the food object
        let food = Task { () -> [String:AnyObject] in
            
            var food: [String:AnyObject] = [:]
            do {
                if #available(iOS 15.0, *) {
                    food = try await performRequest(url: url!)
                } else {
                    // Fallback on earlier versions
                }
            }
            catch {
                print("Request failed with error: \(error)")
            }
            
            return food
        }
        
        return await food.value
        
    }

    // Function that sends the get request to the Edamam food database
    @available(iOS 15.0, *)
    private func performRequest(url: URL) async throws -> [String:AnyObject] {

        let (data, _) = try await URLSession.shared.data(from: url)

        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
        return json
    }
}
