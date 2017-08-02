//
//  AddTipViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 8/2/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit

class AddTipViewController: UIViewController {
    
    var delegate: AddTipDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipTextField: UITextField!
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        if ((tipTextField.text?.isInt) != nil) {
            let tip: Double = Double(tipTextField.text!)! / 100.0
            delegate?.didAddTip(tip: tip)
            
            dismiss(animated: true, completion: nil)
            
        } else {
            _ = UIAlertAction(title: "Must enter valid number", style: .default, handler: { (action) -> Void in
            
            })
            
            
        }
        
//        guard let checkXCoord = x.1["x"].rawValue as? NSNumber else {
//            _ = UIAlertAction(title: "Error, please rescan", style: .default, handler: { (action) -> Void in
//                
//                self.didClickRescan()
//            })
//            
//            return
//        }


        
    }

}
