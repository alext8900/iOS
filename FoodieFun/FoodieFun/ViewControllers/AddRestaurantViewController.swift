//
//  AddRestaurantViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/25/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AddRestaurantViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var review: UITextView!
    
    func giveTextViewaBorder() {
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.5
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        giveTextViewaBorder()

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
        locationTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        review.resignFirstResponder()
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


