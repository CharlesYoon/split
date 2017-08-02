//
//  PaymentTableViewController.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit

class PaymentTableViewController: UITableViewController, AddTipDelegate {

   // @IBOutlet weak var venmoButton: UIButton!
    

    var guestsDataSource: GuestsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (guestsDataSource?.guests.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentTableViewCell

        
        let priceLabel = String(format: "%.2f", arguments: [Double(guestsDataSource!.guests[indexPath.row].mealTotal!)])

        //cell.guestName.text = guestsDataSource!.guests[indexPath.row].name
        cell.priceLabel.text = "$\(priceLabel)"
        cell.guestPic.image = guestsDataSource!.guests[indexPath.row].profPicImage
        cell.guestPic.setRounded()
        cell.guestPic.contentMode = UIViewContentMode.scaleAspectFill
        cell.guestPic.layer.borderWidth = 2
        cell.guestPic.layer.borderColor = UIColor(hex: "F7CE3E").cgColor
        

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navToTip" {
            let tipsVC = segue.destination as! AddTipViewController
            
            tipsVC.delegate = self
            
        }
    }
    
    
    //MARK: Delegate Functions
    
    func didAddTip(tip: Double) {

        //multiply each guest's meal total by tip %
        for guest in (guestsDataSource?.guests)! {
            guest.mealTotal = guest.mealTotal! * (1.0 + tip)
        }
        
        //refresh data to reflect added tip
        self.tableView.reloadData()
    }
    
    


}
