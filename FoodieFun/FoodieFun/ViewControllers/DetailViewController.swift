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
    @IBOutlet weak var hoursOpenAM: UILabel!
    @IBOutlet weak var hoursOpenPM: UILabel!
    @IBOutlet weak var overallRating: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
//    private let addRestaurant = AddRestaurantViewController()
    
    var restaurant: Restaurant?
    
    
    var restaurantController: RestaurantController?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let restaurant = restaurant else { return }
        restaurantController?.deleteRestaurant(restaraunt: restaurant)
        
        navigationController?.popViewController(animated: true)
    }
  

    func updateViews() {
        guard isViewLoaded else { return }
        guard let restaurantObject = restaurant else {
            title = restaurant?.name
            print("Labels not updated")
            return }
        
        print("\(restaurantObject.name) set in detail view")
        title = restaurantObject.name.capitalized
        typeOfCuisine.text = restaurantObject.cuisine
        location.text = restaurantObject.location
    }
    @IBAction func edit(_ sender: UIBarButtonItem!) {
        
    }
    
  


    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
}




