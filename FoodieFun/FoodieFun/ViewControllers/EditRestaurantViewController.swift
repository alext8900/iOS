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
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var openDP: UIDatePicker!
    @IBOutlet weak var closeDP: UIDatePicker!
    
    
    @IBAction func canceButtonTapped(_ sender: UIBarButtonItem) {
        //Go back to previous view controller :)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let addRestaurant = AddRestaurantViewController()
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let name = self.nameTF.text, !name.isEmpty,
        let cuisine = self.cuisineTF.text, !cuisine.isEmpty,
        let location = self.locationTF.text, !location.isEmpty,
        let review = self.review.text, !review.isEmpty,
        let openHour = addRestaurant.getTime(hour: self.openDP.date),
        let closeHour = addRestaurant.getTime(hour: self.closeDP.date) else {
          let alert = UIAlertController(title: "Missing some fields", message: "Check your information and try again.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
          return
        }
        
       

    

    
    // MARK: - Navigation

    }
}
