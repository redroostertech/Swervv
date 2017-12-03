//
//  ProfileViewController.swift
//  BusinessApp
//
//  Created by Michael Westbrooks II on 12/3/17.
//  Copyright © 2017 RedRooster Technologies Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let settingsbutton = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(gotosettings))
        self.navigationItem.rightBarButtonItem = settingsbutton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func gotosettings() {
        self.performSegue(withIdentifier: "Settings", sender: self)
    }

}
