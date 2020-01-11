//
//  DetailViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 1/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func updateModels(restaurant: Restaurant, review: Review)
    
    func didDelete()
}


class DetailViewController: UIViewController {
    
    // MARK: - Outlets and Properties
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
    
    func giveTextViewaBorderAndRound() {
        reviewTextView.layer.borderColor = UIColor.black.cgColor
        reviewTextView.layer.borderWidth = 0.9
        reviewTextView.layer.cornerRadius = 15
    }
    
    enum Rating: Int {
        case one = 1
        case two, three, four, five
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        giveTextViewaBorderAndRound()
        
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

        self.title = restaurant.name.uppercased()
        self.typeOfCuisine.text = restaurant.cuisine
        self.location.text = restaurant.location
        self.hourOpen.text = "\(self.calculateAmPm(militaryTime: restaurant.hour_open))"
        self.hourClosed.text = "\(self.calculateAmPm(militaryTime: restaurant.hour_closed))"
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let restaurant = restaurant else { return }
        restaurantController?.deleteRestaurant(with: restaurant.id, completion: { (restaurant) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSegue" {
            if let nc = segue.destination as? UINavigationController,
                let editVC = nc.topViewController as? EditRestaurantViewController
            {
                editVC.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hue: 355, saturation: 82, brightness: 53, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Quicksand-Bold", size: 42) ?? UIFont.systemFont(ofSize: 42)]
                editVC.restaurantController = self.restaurantController
                editVC.restaurant = self.restaurant
                editVC.review = self.review
                editVC.delegate = self
            }
        }
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
        
        // this is for midnight to 1AM
        if number < 100 {
        stringMilitaryTimeRaw = String(number)
        stringMilitaryTimeRaw = "12" + stringMilitaryTimeRaw
        } else if number < 1000 { // will refactor but this is for one digit hour
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

//extension DetailViewController.Rating {
//    var display: String {
//        switch self {
//        case .one:
//            return "⭐️"
//        case .two:
//            return "⭐️⭐️"
//        case .three:
//            return "⭐️⭐️⭐️"
//        case .four:
//            return "⭐️⭐️⭐️⭐️"
//        case .five:
//            return "⭐️⭐️⭐️⭐️⭐️"
//        }
//    }
//}

extension DetailViewController: DetailViewControllerDelegate {
    func updateModels(restaurant: Restaurant, review: Review) {
        DispatchQueue.main.async {
            self.restaurant = restaurant
            self.review = review
            self.updateViews()
        }
    }
    
    func didDelete() {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
