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
    
    func giveTextViewaBorder() {
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        giveTextViewaBorder()

        // Do any additional setup after loading the view.
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
