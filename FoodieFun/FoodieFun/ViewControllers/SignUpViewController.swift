//
//  SignUpViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    private let userController = UserController()
    
    private let signUpController = SignUpController()
    
    let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    func roundSignupButton() {
        signUpButton.layer.cornerRadius = 12
    }
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.locationTextField.delegate = self
        roundSignupButton()
        
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        // check if all textfields are filled
        guard let username = self.usernameTextField.text, !username.isEmpty,
              let password = self.passwordTextField.text, !password.isEmpty,
              let confirmPassword = self.confirmPasswordTextField.text, !confirmPassword.isEmpty,
              let email = self.emailTextField.text, !email.isEmpty,
              let location = self.locationTextField.text, !location.isEmpty else {
                let alert = UIAlertController(title: "Missing some fields", message: "Check your information and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        // check if the password and the confirm password are match
        guard password == confirmPassword else {
            let alert = UIAlertController(title: "Password doesn't match", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // create a signup form
        let signUpRequest = SignUpRequest(username: username, password: password, location: location, email: email)
        
        // disable the button after the sign up request is created
        self.signUpButton.isEnabled = false
        signUpController.signUp(with: signUpRequest) { (error) in
            // this needs to be in the main thread
            DispatchQueue.main.async {
                if let _ = error {
                    let alert = UIAlertController(title: "Something wrong", message: "Please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    // enable the button if there is an error
                    self.signUpButton.isEnabled = true
                    return
                } else {
                    self.delegate?.loginAfterSignUp(with: LoginRequest(username: username, password: password))
                    self.dismiss(animated: true, completion: nil)
                }
            }
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

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
