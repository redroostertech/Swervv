//
//  InventoryViewController.swift
//  BusinessApp
//
//  Created by Michael Westbrooks II on 12/3/17.
//  Copyright © 2017 RedRooster Technologies Inc. All rights reserved.
//

import UIKit
import BarcodeScanner

class InventoryViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {

    @IBOutlet weak var maintable: UITableView!
    @IBOutlet weak var additem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func add(_ sender: UIButton) {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        self.performSegue(withIdentifier: "CompleteInventoryAdd", sender: self)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        controller.resetWithError(message: "Error Message")
    }
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
