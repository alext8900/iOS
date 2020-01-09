//
//  EditRestaurantViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 1/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class EditRestaurantViewController: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var cuisineTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var openDP: UIDatePicker!
    @IBOutlet weak var closeDP: UIDatePicker!
    @IBOutlet weak var ratingPV: UIPickerView!
    
    var restaurant: Restaurant?
    var restaurantController: RestaurantController?
    var review: Review?
    private var pickerData: [String] = ["1", "2", "3", "4", "5"]
    private var pickedRating: String = "3"
    
    @IBAction func canceButtonTapped(_ sender: UIBarButtonItem) {
        //Go back to previous view controller :)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let restaurant = restaurant else { return }
        
        self.ratingPV.delegate = self
        self.ratingPV.dataSource = self

        self.nameTF.text = self.restaurant?.name
        self.cuisineTF.text = self.restaurant?.cuisine
        self.locationTF.text = self.restaurant?.location
 
        // getting current rating
        guard let defaultRating = self.review?.rating else { return }
        self.ratingPV.selectRow(defaultRating - 1, inComponent: 0, animated: false)
        
        // getting the time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        
        // setting the current open time
        let openTime = setTime(number: restaurant.hour_open)
        guard let openTimeDP = dateFormatter.date(from: openTime) else { return }
        self.openDP.date = openTimeDP
        
        // setting the current closed time
        let closedTime = setTime(number: restaurant.hour_closed)
        guard let closedTimeDP = dateFormatter.date(from: closedTime) else { return }
        self.closeDP.date = closedTimeDP
        
        // setting current reviews
        guard let reviewText = self.review?.review else { return }
        self.reviewTextView.text = reviewText
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
//        guard let name = self.nameTF.text, !name.isEmpty,
//        let cuisine = self.cuisineTF.text, !cuisine.isEmpty,
//        let location = self.locationTF.text, !location.isEmpty,
//        let review = self.review.text, !review.isEmpty,
//        let openHour = addRestaurant.getTime(hour: self.openDP.date),
//        let closeHour = addRestaurant.getTime(hour: self.closeDP.date) else {
//          let alert = UIAlertController(title: "Missing some fields", message: "Check your information and try again.", preferredStyle: .alert)
//          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//          self.present(alert, animated: true, completion: nil)
//          return
//        }
    }
    
    func setTime(number: Int) -> String {
        var stringMilitaryTimeRaw: String
        
        // will refactor but this is for midnight to 1AM
        if number < 100 {
        stringMilitaryTimeRaw = String(number)
        stringMilitaryTimeRaw = "00" + stringMilitaryTimeRaw
        } else if number < 1000 { // will refactor but this is for one digit hour
        stringMilitaryTimeRaw = String(number)
        stringMilitaryTimeRaw = "0" + stringMilitaryTimeRaw
        } else {
            stringMilitaryTimeRaw = String(number)
        }
        
        return stringMilitaryTimeRaw
    }

    // MARK: - Navigation
}

extension EditRestaurantViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickedRating = String(row)
        print(pickedRating)
    }
}
