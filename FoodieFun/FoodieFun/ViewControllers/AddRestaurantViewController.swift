//
//  AddRestaurantViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/25/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AddRestaurantViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cuisineTF: UITextField!
    
    @IBAction func addButtonPressed() {
        hideKeyBoard()
    }
    
    func addButtonViewDidLoad() {
        addButton.layer.cornerCurve = .continuous
        addButton.layer.cornerRadius = 8
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 1
    }
    
    func giveTextViewaBorder() {
        review.layer.cornerCurve = .continuous
        review.layer.cornerRadius = 12
        review.layer.borderColor = UIColor.black.cgColor
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

    override func viewDidLoad() {
        super.viewDidLoad()
        giveTextViewaBorder()
        addObservers()
        textFieldDelegates()
        addButtonViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardRectInScrollView = view.convert(keyboardRect, from: nil)
        
        let screenIntersection = view.bounds.height - keyboardRectInScrollView.origin.y
        
        var scrollViewInsets = scrollView.contentInset
        
        scrollViewInsets.bottom = screenIntersection
        
        scrollView.contentInset = scrollViewInsets
        scrollView.scrollIndicatorInsets = scrollViewInsets
    }
    
    func hideKeyBoard() {
//        locationTF.resignFirstResponder()
//        nameTF.resignFirstResponder()
//        review.resignFirstResponder()
//        cuisineTF.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print(textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var reviewString = review.text else { return false }
        guard var nameString = nameTF.text else { return false }
        guard var locationString = locationTF.text else { return false }
        
        return true
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


