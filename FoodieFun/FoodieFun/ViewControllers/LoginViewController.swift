//
//  LoginViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginAfterSignUp(with loginRequest: LoginRequest)
}

class LoginViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginController = LoginController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    // MARK: - Actions and Methods
    @IBAction func login(_ sender: UIButton) {
        // checking the textfield if username and password exist
        guard let username = self.usernameTextField.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty else { return }
        
        // create a login request
        let loginRequest = LoginRequest(username: username, password: password)
        self.login(with: loginRequest)
    }
    
    func login(with loginRequest: LoginRequest) {
        loginController.login(with: loginRequest) { (error) in
            if let error = error {
                NSLog("Error occured during login: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "DashboardSegue", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            guard let vc = segue.destination as? SignUpViewController else { return }
            vc.delegate = self
        }
    }
}

extension LoginViewController: LoginViewControllerDelegate {
    func loginAfterSignUp(with loginRequest: LoginRequest) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.login(with: loginRequest)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
