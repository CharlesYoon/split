//
//  ItemTableViewCell.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var isAssigned: Bool? = false
    var itemID: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
