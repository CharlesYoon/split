//
//  Guest.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import Foundation
import UIKit
import Gloss


//adding AnyObject, make sure to look back at this if anything breaks
//!!!!!!!!!!!!!!
class Guest{
    var name: String?
    var guestID: String? = ""
    var venmoName: String?
    var profPicURL: String? = ""
    var profPicImage: UIImage?
    var paymentComplete: Bool?
    var mealTotal: Double?
    var items: [Item]
    
    required init() {
        self.name = ""
        self.venmoName = ""
        //self.profPicURL = ""
        self.paymentComplete = false
        self.mealTotal = 0.0
        self.items = []
    }
    
    init(profPicImage: UIImage?, guestID: String) {
        self.name = ""
        self.venmoName = ""
        self.profPicImage = profPicImage
        self.paymentComplete = false
        self.mealTotal = 0.0
        self.items = []
        self.guestID = guestID
    }
    
    init(name: String?, venmoName: String?, profPicURL: String?) {
        self.name = name
        self.venmoName = venmoName
        self.profPicURL = profPicURL
        //self.profPicImage = profPicImage
        self.paymentComplete = false
        self.mealTotal = 0.0
        self.items = []
    }
    
    init(guestID: String?, name: String?, profPicURL: String?) {
        self.name = name
        self.guestID = guestID
        self.venmoName = ""
//        self.profPicImage = profPicImage
        self.profPicURL = profPicURL
        self.paymentComplete = false
        self.mealTotal = 0.0
        self.items = []
    }
    
    init(dictionary: [String: AnyObject], key: String? = nil) {
        self.guestID = key
        self.name = dictionary["name"] as? String
        self.venmoName = dictionary["venmoName"] as? String
        self.profPicURL = dictionary["profPicURL"] as? String
        self.paymentComplete = dictionary["paymentComplete"] as? Bool
        self.mealTotal = dictionary["mealTotal"] as? Double
        self.items = []
    }
    
    required init?(json: JSON) {
        self.name = "name" <~~ json
        self.guestID = "guestID" <~~ json
        self.venmoName = "venmoName" <~~ json
        //self.profPicURL = "profPicURL" <~~ json
        self.paymentComplete = "paymentComplete" <~~ json
        self.mealTotal = "mealTotal" <~~ json
        self.items = []
    }
    

    func toJSON() -> JSON? {
        return jsonify([
            //"guestID" ~~> self.guestID,
            "name" ~~> self.name,
            //            "userID" ~~> self.userID,
            "venmoName" ~~> self.venmoName,
            "profPicURL" ~~> self.profPicURL,
            "paymentComplete" ~~> self.paymentComplete,
            "mealTotal" ~~> self.mealTotal
            ])
    }
    
}
