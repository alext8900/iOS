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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giveTextViewaBorder()
        addObservers()
        textFieldDelegates()
//        addButtonViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonPressed() {
        hideKeyBoard()
    }
    
//    func addButtonViewDidLoad() {
//        addButton.layer.cornerCurve = .continuous
//        addButton.layer.cornerRadius = 8
//        addButton.layer.borderColor = UIColor.black.cgColor
//        addButton.layer.borderWidth = 1
//    }
    
    func giveTextViewaBorder() {
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
        hideKeyBoard()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldFrame = scrollView.convert(textField.bounds, from: textField)
        
        scrollView.scrollRectToVisible(textFieldFrame, animated: true)
    }
}


