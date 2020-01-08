//
//  DetailViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 1/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var typeOfCuisine: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var hourOpen: UILabel!
    @IBOutlet weak var hourClosed: UILabel!
    @IBOutlet weak var overallRating: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var restaurant: Restaurant?
    var restaurantController: RestaurantController?
    var review: Review? {
        didSet {
            DispatchQueue.main.async {
                self.reviewTextView.text = self.review?.review
                self.overallRating.text = "\(self.review?.rating ?? 1)"
            }
        }
    }
    
    enum Rating: Int {
        case one = 1
        case two, three, four, five
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        guard let restaurant = self.restaurant else { return }
        restaurantController?.fetchReviews(with: restaurant.id, completion: { (result) in
            if let reviews = try? result.get() {
                self.review = reviews.first
            }
        })
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        guard let restaurant = self.restaurant else { return }

        self.title = restaurant.name.capitalized
        self.typeOfCuisine.text = restaurant.cuisine
        self.location.text = restaurant.location
        self.hourOpen.text = "\(self.calculateAmPm(militaryTime: restaurant.hour_open))"
        self.hourClosed.text = "\(self.calculateAmPm(militaryTime: restaurant.hour_closed))"
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let restaurant = restaurant else { return }
        restaurantController?.deleteRestaurant(restaraunt: restaurant)
    }

    @IBAction func edit(_ sender: UIBarButtonItem!) {
        
    }
}

extension DetailViewController {
    // for converting the hours from military time to regular time AM PM
    func calculateAmPm(militaryTime: Int) -> String {
        let militaryTimeRaw: Int
        
        if militaryTime > 1200 {
            militaryTimeRaw = militaryTime - 1200
            let stringFullHour = stringConverter(number: militaryTimeRaw)
            return stringFullHour + " PM"
        } else {
            militaryTimeRaw = militaryTime
            let stringFullHour = stringConverter(number: militaryTimeRaw)
            return stringFullHour + " AM"
        }
    }

    func stringConverter(number: Int) -> String {
        var stringMilitaryTimeRaw: String
        
        if number < 1000 {
            stringMilitaryTimeRaw = String(number)
            stringMilitaryTimeRaw = "0" + stringMilitaryTimeRaw
        } else {
            stringMilitaryTimeRaw = String(number)
        }
        
        let stringHour = stringMilitaryTimeRaw.prefix(2)
        let stringMinute = stringMilitaryTimeRaw.suffix(2)
        let stringFullHour = stringHour + "." + stringMinute
        return String(stringFullHour)
    }
}

// will set this up later
extension DetailViewController.Rating {
    var display: String {
        switch self {
        case .one:
            return "⭐️"
        case .two:
            return "⭐️⭐️"
        case .three:
            return "⭐️⭐️⭐️"
        case .four:
            return "⭐️⭐️⭐️⭐️"
        case .five:
            return "⭐️⭐️⭐️⭐️⭐️"
        }
    }
}

