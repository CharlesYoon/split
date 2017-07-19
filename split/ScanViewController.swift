//
//  ScanViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/10/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import Alamofire

class ScanViewController: UIViewController {

    @IBOutlet weak var receiptRaw: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var receiptScanned: UIImageView!

    
    var items: [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Will delete this once real OCR is implemented
        receiptRaw.isHidden = false
        receiptScanned.isHidden = true
        scanButton.isHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func scanReceipt(_ sender: Any) {
        
        receiptRaw.isHidden = true
        receiptScanned.isHidden = false
        scanButton.isHidden = true
        self.navigationItem.title = "Select Items"
    }
    
    @IBAction func scanFinished(_ sender: Any) {
        
//        var items: [Item] = []
        
        
        // HARD CODED FOR SAKE OF EXAMPLE - DELETE
        
        //Clears Items data to reset
        Alamofire.request("https://split2-62ca2.firebaseio.com/items.json", method: .delete)
        
        
        var singleItem = Item(name: "Cappuccino 355mL", price: 2.99)
        
        items.append(singleItem)
        
        singleItem = Item(name: "Black Label 340mL", price: 2.49)
        items.append(singleItem)
        
        singleItem = Item(name: "Black Label Beer 340ML", price: 2.49)
        items.append(singleItem)
        
        singleItem = Item(name: "Castle Lite 500mL", price: 2.49)
        items.append(singleItem)
        
        singleItem = Item(name: "Bottle Water 1L", price: 1.25)
        items.append(singleItem)
        
        singleItem = Item(name: "Chicken Malay Wrap", price: 5.75)
        items.append(singleItem)
        
        singleItem = Item(name: "Dim Sum", price: 9.99)
        items.append(singleItem)
        
        singleItem = Item(name: "Primi Breakfast Burrito", price: 8.00)
        items.append(singleItem)
        
        singleItem = Item(name: "Wild Springbok Filet", price: 14.99)
        items.append(singleItem)
        
        singleItem = Item(name: "Hot Pot Special", price: 12.49)
        items.append(singleItem)
        
        singleItem = Item(name: "Roxy's Happy Hour Bucket", price: 4.61)
        items.append(singleItem)
        
        singleItem = Item(name: "Roxy's Happy Hour Bucket", price: 4.61)
        items.append(singleItem)
        
        singleItem = Item(name: "Roxy's Happy Hour Bucket", price: 4.61)
        items.append(singleItem)
        
        
        
        // DELETE THE ENCAPSULATED CODE LATER
        
        
        //Add all receipt items to firebase
        for item in items {
            Alamofire.request("https://split2-62ca2.firebaseio.com/items.json", method: .post, parameters: item.toJSON(), encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
                
                switch response.result {
                case .success:
                    //                self.delegate?.didAddActivity(activity: activityDto!)
                    //self.dismiss(animated: true, completion: nil)
                    break
                case .failure:
                    // TODO: Display an error dialog
                    break
                }
                
            })
        }
        
        
        
        
        performSegue(withIdentifier: "navToGuests", sender: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
