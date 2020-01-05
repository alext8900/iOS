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
    private var pickerData: [String] = [String]()
    private var pickedRating: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giveTextViewaBorder()
        addObservers()
        textFieldDelegates()
        
        self.ratingPV.delegate = self
        self.ratingPV.dataSource = self
        
        pickerData = ["⭐️", "⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️⭐️"]
    }
    
    @IBAction func saveButtonPressed() {
        guard let name = self.nameTF.text, !name.isEmpty,
              let cuisine = self.cuisineTF.text, !cuisine.isEmpty,
              let location = self.locationTF.text, !location.isEmpty else { return }
            
        let openHour = self.openDP.date
        let closeHour = self.closeDP.date
        
        let calendar = Calendar.current
        let compOpen = calendar.dateComponents([.hour, .minute], from: openHour)
        guard let openHourDP = compOpen.hour else { return }
        guard let openMinuteDP = compOpen.minute else { return }
        guard let from = Int(String(openHourDP) + String(openMinuteDP)) else { return }
        
        let compClose = calendar.dateComponents([.hour, .minute], from: closeHour)
        guard let closeHourDP = compClose.hour else { return }
        guard let closeMinuteDP = compClose.minute else { return }
        guard let to = Int(String(closeHourDP) + String(closeMinuteDP)) else { return }
        
//        self.restaurantController.addRestaurant(withName: name,
//                                                type: cuisine,
//                                                at: location,
//                                                from: from, to: to) { (data, error) in
//                                                    <#code#>
//        }
        
        hideKeyBoard()
        
        
    }
    
    @IBAction func openHourChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.short
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
        print(textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let reviewString = review.text else { return false }
        guard let nameString = nameTF.text else { return false }
        guard let locationString = locationTF.text else { return false }
        
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
        hideKeyBoard()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldFrame = scrollView.convert(textField.bounds, from: textField)
        
        scrollView.scrollRectToVisible(textFieldFrame, animated: true)
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
