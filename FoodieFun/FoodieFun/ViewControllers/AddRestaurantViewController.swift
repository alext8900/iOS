//
//  AddRestaurantViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/25/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AddRestaurantViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var cuisineTF: UITextField!
    @IBOutlet weak var openDP: UIDatePicker!
    @IBOutlet weak var closeDP: UIDatePicker!
    @IBOutlet weak var ratingPV: UIPickerView!
    @IBOutlet weak var photoView: UIImageView!
    
    private let restaurantController = RestaurantController()
    private var pickerData: [String] = ["⭐️", "⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️⭐️"]
    private var pickedRating: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giveTextViewaBorder()
        addObservers()
        textFieldDelegates()
        
        self.ratingPV.delegate = self
        self.ratingPV.dataSource = self
    }
    
    @IBAction func saveButtonPressed() {
        guard let name = self.nameTF.text, !name.isEmpty,
              let cuisine = self.cuisineTF.text, !cuisine.isEmpty,
              let location = self.locationTF.text, !location.isEmpty,
              let review = self.review.text, !review.isEmpty,
              let openHour = self.getTime(hour: self.openDP.date),
              let closeHour = self.getTime(hour: self.closeDP.date) else {
                let alert = UIAlertController(title: "Missing some fields", message: "Check your information and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        self.restaurantController.addRestaurant(name: name,
                                                cuisine: cuisine,
                                                location: location,
                                                openTime: openHour,
                                                closeTime: closeHour) { (result) in
                                                    switch result {
                                                    case .failure(let error):
                                                        print(error)
                                                    case .success(let restaurant):
                                                        self.createReview(restaurant: restaurant, review: review)
                                                    }
        }
    }
    
    private func getTime(hour: Date) -> Int? {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour, .minute], from: hour)
        guard let timeHourInt = component.hour else { return nil }
        guard let timeMinuteInt = component.minute else { return nil }
        var timeMinuteIntToString: String = ""
        if timeMinuteInt == 0 {
            timeMinuteIntToString = String(timeMinuteInt) + "0"
        } else {
            timeMinuteIntToString = String(timeMinuteInt)
        }
        
        // change to String first in order to combine hour and minute as one unit of Int for the backend purpose
        guard let militaryTime = Int(String(timeHourInt) + timeMinuteIntToString) else { return nil }
        return militaryTime
    }
    
    // getting second request for review after creating a new restaurant
    private func createReview(restaurant: Restaurant, review: String) {
        guard let pickedRatingInt = Int(self.pickedRating) else { return }
        // create a review
        self.restaurantController.addReview(restaurantId: restaurant.id,
                                            cuisine: restaurant.cuisine,
                                            name: restaurant.name,
                                            rating: pickedRatingInt,
                                            review: review) { (result) in
                                                switch result {
                                                case .failure(let error):
                                                    print(error)
                                                case .success(let review):
                                                    print(review)
                                                }
        }
    }

    @IBAction func openHourChanged(_ sender: Any) {
    }
    
    @IBAction func closeHourChanged(_ sender: Any) {
    }
    
    private func giveTextViewaBorder() {
        review.layer.cornerCurve = .continuous
        review.layer.cornerRadius = 8
        review.layer.borderColor = UIColor.gray.cgColor
        review.layer.borderWidth = 0.5
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDelegates() {
        cuisineTF.delegate = self
        locationTF.delegate = self
        nameTF.delegate = self
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // calculate the height of the status bar and the navigation bar
        let navbarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + ( self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        var scrollViewInsets = scrollView.contentInset
        scrollViewInsets.bottom = keyboardRect.height - navbarHeight

        scrollView.contentInset = scrollViewInsets
        scrollView.scrollIndicatorInsets = scrollViewInsets
    }
    
    func hideKeyBoard() {
        locationTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        review.resignFirstResponder()
        cuisineTF.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var reviewString = review.text else { return false }
        guard var nameString = nameTF.text else { return false }
        guard var locationString = locationTF.text else { return false }
        
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension AddRestaurantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension AddRestaurantViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        print(pickedRating)
    }
    
}
