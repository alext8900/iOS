//
//  RestaurantController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 1/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation


class RestaurantController {
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://bw-foodiefun.herokuapp.com/api")!
    var restaurants: [Restaurant] = []
    var loginController = LoginController.shared
    
    func addRestaurant(withName name: String,
                       type cuisine: String,
                       at location: String,
                       from openTime: Int,
                       to closeTime: Int,
                       for days: String = "7 days",
                       withURL url: String,
                       completion: @escaping (Result<Restaurant, NetworkError>) -> Void)
    {
        let requestURL = baseURL.appendingPathComponent("/restaurants/")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(LoginController.shared.token?.token, forHTTPHeaderField: "Authorization")
        
        // create a new restaurant internally
        guard let userId = LoginController.shared.token?.id else { return }
        let newRestaurantRequest = RestaurantRequest(name: name,
                                                     cuisine: cuisine,
                                                     location: location,
                                                     hour_open: openTime,
                                                     hour_closed: closeTime,
                                                     days_open: days,
                                                     user_id: userId,
                                                     photo_url: url)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(newRestaurantRequest)
            request.httpBody = jsonData
        } catch {
            print("Error encoding restaurant object: \(error.localizedDescription)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.badAuth))
            }
            
            if let _ = error {
                completion(.failure(.otherError));
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData));
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let restaurant = try decoder.decode(Restaurant.self, from: data)
                self.restaurants.append(restaurant)
                completion(.success(restaurant))
                
            } catch {
                print("Error decoding restaurant after creating: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    
}
