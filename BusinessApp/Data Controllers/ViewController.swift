//
//  ViewController.swift
//  BusinessApp
//
//  Created by Michael Westbrooks II on 12/2/17.
//  Copyright © 2017 RedRooster Technologies Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var keyboardconstraint: NSLayoutConstraint!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var emailtext: String? {
        didSet {
            email.text = emailtext
        }
    }
    var passwordtext: String? {
        didSet {
            password.text = passwordtext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginaction(_ sender: UIButton) {
    }
}

