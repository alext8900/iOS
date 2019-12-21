//
//  InitialLoginViewController.swift
//  FoodieFun
//
//  Created by Alex Thompson on 12/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

import MapKit

class InitialLoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        roundLoginButtonEdgesAndaBorder()

        // Do any additional setup after loading the view.
    }
    
    func roundLoginButtonEdgesAndaBorder() {
        loginButton.layer.cornerRadius = 12
        loginButton.layer.cornerCurve = .continuous
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 1
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
