//
//  EditRestaurantViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 1/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class EditRestaurantViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var scrollView: UIScrollView!
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
    private var pickedRating: String?
    weak var delegate: DetailViewControllerDelegate?
    
    @IBAction func canceButtonTapped(_ sender: UIBarButtonItem) {
        //Go back to previous view controller :)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.giveTextViewaBorder()
        self.addObservers()
        
        super.viewDidLoad()
        guard let restaurant = restaurant else { return }
        
        self.ratingPV.delegate = self
        self.ratingPV.dataSource = self

        self.nameTF.text = self.restaurant?.name
        self.cuisineTF.text = self.restaurant?.cuisine
        self.locationTF.text = self.restaurant?.location
 
        // getting current rating
        guard let defaultRating = self.review?.rating else { return }
        self.pickedRating = String(defaultRating)
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
    
    @IBAction func saveButtonPressed() {
        guard let restaurant = self.restaurant,
            let name = self.nameTF.text,
            let cuisine = self.cuisineTF.text,
            let location = self.locationTF.text,
            let newReview = self.reviewTextView.text,
            let openHour = self.getTime(hour: self.openDP.date),
            let closeHour = self.getTime(hour: self.closeDP.date) else { return }
        
        self.restaurantController?.updateRestaurant(id: restaurant.id, name: name, cuisine: cuisine, location: location, openTime: openHour, closeTime: closeHour, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let restaurant):
                guard let pickedRating = self.pickedRating,
                    let pickedRatingInt = Int(pickedRating),
                    let reviewId = self.review?.id else { return }
                
                self.restaurantController?.updateReview(id: reviewId, restaurantId: restaurant.id, cuisine: restaurant.cuisine, name: restaurant.name, url: restaurant.photo_url, rating: pickedRatingInt, review: newReview, completion: { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success( let review):
                        print(review)
                        self.delegate?.updateModels(restaurant: restaurant, review: review)
                    }
                })
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var scrollViewInsets = scrollView.contentInset
        scrollViewInsets.bottom = keyboardRect.height

        scrollView.contentInset = scrollViewInsets
        scrollView.scrollIndicatorInsets = scrollViewInsets
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private func giveTextViewaBorder() {
        reviewTextView.layer.cornerCurve = .continuous
        reviewTextView.layer.cornerRadius = 8
        reviewTextView.layer.borderColor = UIColor.gray.cgColor
        reviewTextView.layer.borderWidth = 0.5
    }
    
    private func setTime(number: Int) -> String {
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
    
    private func getTime(hour: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: hour)
        guard let timeHourInt = components.hour else { return nil }
        guard let timeMinuteInt = components.minute else { return nil }
        
        var timeHourIntToString: String = ""
        var timeMinuteIntToString: String = ""

        if timeHourInt == 0 {
            timeHourIntToString = String(timeHourInt) + "0"
        } else {
            timeHourIntToString = String(timeHourInt)
        }
        
        if timeMinuteInt == 0 {
            timeMinuteIntToString = String(timeMinuteInt) + "0"
        } else {
            timeMinuteIntToString = String(timeMinuteInt)
        }
        
        // change to String first in order to combine hour and minute as one unit of Int for the backend purpose
        guard let militaryTime = Int(String(timeHourIntToString) + timeMinuteIntToString) else { return nil }
        return militaryTime
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        guard let restaurant = restaurant else { return }
          restaurantController?.deleteRestaurant(with: restaurant.id, completion: { (restaurant) in
            self.delegate?.didDelete()
          })
    }
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
        self.pickedRating = String(row + 1)
    }
}

