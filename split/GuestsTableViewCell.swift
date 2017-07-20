//
//  GuestsTableViewCell.swift
//  split
//
//  Created by Brandon Taleisnik on 7/10/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit

class GuestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var guestImage: UIImageView!
//    @IBOutlet weak var guestName: UILabel!
//    @IBOutlet weak var guestVenmo: UILabel!
    //@IBOutlet weak var spinner: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
