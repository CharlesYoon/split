//
//  PaymentTableViewCell.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var guestPic: UIImageView!
    @IBOutlet weak var guestName: UILabel!
    @IBOutlet weak var owesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //Change format of Button when pressed
    @IBAction func payButtonPressed(_ sender: Any) {
        payButton.backgroundColor = UIColor(hex: "89FA67")

        payButton.setTitle("Venmo Sent",for: .normal)


    }
}
