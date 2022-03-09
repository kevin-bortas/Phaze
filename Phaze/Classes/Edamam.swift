//
//  Edamam.swift
//  Phaze
//
//  Created by Kevin Bortas on 03/03/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Edamam {
    
    let food_appid: String
    let food_appkey: String
    
    init(){
        self.food_appid = "f635a9ab"
        self.food_appkey = "fee3c57a8a37a553efef8356f775f5c3"
    }
    
    func get(query: String) async -> [String:Any] {
        let splitQuery = query.lowercased().split(separator: " ")
        var constructedQuery: String
        if (splitQuery.count > 1){
            constructedQuery = splitQuery.joined(separator: "%20")
        }
        else {
            constructedQuery = splitQuery.joined(separator: "")
        }
        
        let requestString = "https://api.edamam.com/api/food-database/v2/parser?app_id=f635a9ab&app_key=fee3c57a8a37a553efef8356f775f5c3&nutrition-type=cooking&ingr=" + constructedQuery
        
        let url = URL(string: requestString)!
        
        let food = Task { () -> [String:Any] in
            
            var food: [String:Any] = [:]
            do {
                if #available(iOS 15.0, *) {
                    food = try await performRequest(url: url)
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

    @available(iOS 15.0, *)
    private func performRequest(url: URL) async throws -> [String:Any] {

        let (data, _) = try await URLSession.shared.data(from: url)

        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
        return json
    }
}
