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
    var reviews: [Review] = []
    var loginController = LoginController.shared
    
    func fetchAllRestaurants(completion: @escaping (Result<[Restaurant], NetworkError>) -> Void)
    {
        let requestURL = baseURL.appendingPathComponent("/restaurants/")
        var request = URLRequest(url: requestURL)
        
        guard let userId = loginController.token?.id else { return }
        let stringUserId = String(userId)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        request.setValue(stringUserId, forHTTPHeaderField: "user_id")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
            }
            
            if let _ = error {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let restaurants = try decoder.decode([Restaurant].self, from: data)
                completion(.success(restaurants))
            } catch {
                print("Error decoding restaurants: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func addRestaurant(name: String,
                       cuisine: String,
                       location: String,
                       openTime: Int,
                       closeTime: Int,
                       days: String = "7 days",
                       url: String = "www.lambdaschool.com",
                       completion: @escaping (Result<Restaurant, NetworkError>) -> Void)
    {
        let requestURL = baseURL.appendingPathComponent("/restaurants/")
        var request = URLRequest(url: requestURL)
        
        guard let userId = loginController.token?.id else { return }
        let stringUserId = String(userId)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        request.setValue(stringUserId, forHTTPHeaderField: "user_id")
        
        // create a new restaurant internally
        let newRestaurantRequest = RestaurantRequest(name: name,
                                                     cuisine: cuisine,
                                                     location: location,
                                                     hour_open: openTime,
                                                     hour_closed: closeTime,
                                                     days_open: days,
                                                     user_id: userId,
                                                     photo_url: url)
        print(newRestaurantRequest)
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
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
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
    
    func addReview(restaurantId: Int,
                   cuisine: String,
                   name: String,
                   url: String = "www.lambdaschool.com",
                   rating: Int,
                   review: String,
        completion: @escaping (Result<Review, NetworkError>) -> Void)
    {
        let requestURL = baseURL.appendingPathComponent("/items/")
        var request = URLRequest(url: requestURL)
        
        guard let userId = loginController.token?.id else { return }
        let stringUserId = String(userId)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        request.setValue(stringUserId, forHTTPHeaderField: "user_id")
        
        // create a new review internally
        let newReviewRequest = ReviewRequest(restaurant_id: restaurantId,
                                      cuisine: cuisine,
                                      name: name,
                                      photo_url: url,
                                      rating: rating,
                                      review: review,
                                      user_id: userId)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(newReviewRequest)
            request.httpBody = jsonData
        } catch {
            print("Error encoding review object: \(error.localizedDescription)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.badAuth))
            }
            
            if let _ = error {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let review = try decoder.decode(Review.self, from: data)
                self.reviews.append(review)
                completion(.success(review))
            } catch {
                print("Error decoding review after creating: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func updateRestaurant(id: Int,
                          name: String,
                          cuisine: String,
                          location: String,
                          openTime: Int,
                          closeTime: Int,
                          days: String = "7 days",
                          url: String = "www.lambdaschool.com",
                          completion: @escaping (Result<Restaurant, NetworkError>) -> Void)
    {
        guard let index = self.restaurants.firstIndex(where: { restaurant in restaurant.id == id }) else { return }
        
        var updatedRestaurant = self.restaurants[index]
        updatedRestaurant.name = name
        updatedRestaurant.cuisine = cuisine
        updatedRestaurant.location = location
        updatedRestaurant.hour_open = openTime
        updatedRestaurant.hour_closed = closeTime
        updatedRestaurant.days_open = days
        updatedRestaurant.photo_url = url
        
        // set it back
        self.restaurants[index] = updatedRestaurant
        
        let requestURL = baseURL.appendingPathComponent("/restaurants/\(id)")
        var request = URLRequest(url: requestURL)
        
        guard let userId = loginController.token?.id else { return }
        let stringUserId = String(userId)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        request.setValue(stringUserId, forHTTPHeaderField: "user_id")
 
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(updatedRestaurant)
            request.httpBody = jsonData
        } catch {
            print("Error encoding updateObject: \(error.localizedDescription)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
            }
            
            if let _ = error {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let restaurant = try decoder.decode(Restaurant.self, from: data)
                self.restaurants.append(restaurant)
                completion(.success(restaurant))
            } catch {
                print("Error decoding updated restaurant after updating: \(error)")
                
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func updateReview(id: Int,
                      restaurantId: Int,
                      cuisine: String,
                      name: String,
                      url: String,
                      rating: Int,
                      review: String,
                      completion: @escaping (Result<Review, NetworkError>) -> Void)
    {
        let requestURL = baseURL.appendingPathComponent("/items/\(id)")
        var request = URLRequest(url: requestURL)
        
        guard let userId = loginController.token?.id else { return }
        let stringUserId = String(userId)
        
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        request.setValue(stringUserId, forHTTPHeaderField: "user_id")
        
        let updatedReview = Review(id: id, restaurant_id: restaurantId, cuisine: cuisine, name: name, photo_url: url, rating: rating, review: review, user_id: userId)
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(updatedReview)
            request.httpBody = jsonData
        } catch {
            print("Error encoding updateObject: \(error.localizedDescription)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
            }
            
            if let _ = error {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let review = try decoder.decode(Review.self, from: data)
                self.reviews.append(review)
                completion(.success(review))
            } catch {
                print("Error decoding updated review after updating: \(error)")
                
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }

    func fetchReviews(with id: Int, completion: @escaping (Result<[Review], NetworkError>) -> Void)
    {
        let requestURL = baseURL.appendingPathComponent("/restaurants/\(id)/items")
        var request = URLRequest(url: requestURL)
        
        guard let userId = loginController.token?.id else { return }
        let stringUserId = String(userId)

        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        request.setValue(stringUserId, forHTTPHeaderField: "user_id")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(.failure(.badAuth))
            }
            
            if let _ = error {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let reviews = try decoder.decode([Review].self, from: data)
                completion(.success(reviews))
            } catch {
                print("Error decoding all reviews: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func deleteRestaurant(with id: Int, completion: @escaping (Result<Restaurant, NetworkError>) -> Void)
    {
        
        let requestURL = baseURL.appendingPathComponent("/restaurants/\(id)")
        
        var request = URLRequest(url: requestURL)
        
        guard let userId = loginController.token?.id else { return }
        let stringUserId = String(userId)
        
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        request.setValue(stringUserId, forHTTPHeaderField: "user_id")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 204 {
                completion(.failure(.badAuth))
            }
            
            if let _ = error {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()

            do {
                let restaurant = try decoder.decode(Restaurant.self, from: data)
                completion(.success(restaurant))
            } catch {
                print("Error decoding restaurant after deleting: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
}
