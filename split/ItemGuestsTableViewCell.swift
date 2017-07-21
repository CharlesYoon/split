//
//  ItemGuestsTableViewCell.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit

class ItemGuestsTableViewCell: UITableViewCell {

    @IBOutlet weak var guestPic: UIImageView!
//    @IBOutlet weak var guestName: UILabel!
    
//    var guest: Guest?
    var guestID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
