//
//  Items.swift
//  split
//
//  Created by Brandon Taleisnik on 7/12/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import Foundation
import Gloss

class Item {
    var name: String?
    var price: Double?
    var isAssigned: Bool?
    var itemID: String? = ""
    
    init() {
        self.name = ""
        self.price = 0.0
        self.isAssigned = false
    }
    
    init(name: String?, price: Double?, itemID: String? = nil) {
        self.name = name
        self.price = price
        self.isAssigned = false
        self.itemID = itemID
    }
    
    init(dictionary: [String: AnyObject], key: String? = nil) {
        self.name = dictionary["name"] as? String
        self.price = dictionary["price"] as? Double
        self.isAssigned = dictionary["isAssigned"] as? Bool
        self.itemID = key
    }
    
    
    required init?(json: JSON) {
        self.name = "name" <~~ json
        self.price = "price" <~~ json
        self.isAssigned = "isAssigned" <~~ json
        self.itemID = "itemID" <~~ json
    }
    
    
    func toJSON() -> JSON? {
        return jsonify([
            "name" ~~> self.name,
            "price" ~~> self.price,
            "isAssigned" ~~> self.isAssigned
        ])
    }

}
