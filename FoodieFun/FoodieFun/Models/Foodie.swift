//
//  Foodie.swift
//  FoodieFun
//
//  Created by Alex Thompson on 1/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Foodie: Decodable {
    let restaurantName: String?
    let category: Category
    let id: String?
    let cuisineType: String?
    let menuItemName: String?
    let menuItemPhoto: String?
    let recentlyVisited: String?
    let menuItemRating: String?
    let restaurantRating: String?
    
    enum Category: Decodable {
        case all
        case restaurants
        case menu
        case ratings
        case cuisine
    }
}

extension Foodie.Category: CaseIterable { }

extension Foodie.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "All": self = .all
        case "Restaurants": self = .restaurants
        case "Menu": self = .menu
        case "Ratings": self = .ratings
        case "Cuisine": self = .cuisine
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .all: return "All"
        case .restaurants: return "Restaurants"
        case .menu: return "Menu"
        case .ratings: return "Ratings"
        case .cuisine: return "Cuisine"
        }
    }
}

extension Foodie {
    static func foodies() -> [Foodie] {
        guard
            let searchURL = URL(string: "https://bw-foodiefun.herokuapp.com/api/restaurants/"),
        let data = try? Data(contentsOf: searchURL)
            else {
                return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Foodie].self, from: data)
        } catch {
            return []
        }
    }
}




