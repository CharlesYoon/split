//
//  GuestDTO.swift
//  split
//
//  Created by Charles Yoon on 7/19/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON
import SwiftyJSONRealmObject


class GuestDTO: Object{
    dynamic var name: String?
    dynamic var guestID: String? = ""
    dynamic var venmoName: String?
    dynamic var profPicURL: String? = ""
    dynamic var profPicImage: UIImage?
    dynamic var paymentComplete: Bool
    dynamic var mealTotal: Double = 0.0
    var items: [Item]?
    
    init(name: String?, venmoName: String?, profPicURL: String?) {
        self.name = name
        self.venmoName = venmoName
        self.profPicURL = profPicURL
        //self.profPicImage = profPicImage
        self.paymentComplete = false
        self.mealTotal = 0.0
        self.items = []
        super.init()
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
        super.init()
    }
    
    init(dictionary: [String: AnyObject], key: String? = nil) {
        self.guestID = key
        self.name = dictionary["name"] as? String
        self.venmoName = dictionary["venmoName"] as? String
        self.profPicURL = dictionary["profPicURL"] as? String
        self.paymentComplete = (dictionary["paymentComplete"] as? Bool)!
        self.mealTotal = (dictionary["mealTotal"] as? Double)!
        self.items = []
        super.init()
    }
    
    //jsonify from Realm
    required init?(json: JSON) {
        self.name = json["name"].stringValue
        self.guestID = json["guestID"].stringValue
        self.venmoName = json["venmoName"].stringValue
        //self.profPicURL = "profPicURL" <~~ json
        self.paymentComplete = json["paymentComplete"].boolValue
        self.mealTotal = json["mealTotal"].doubleValue
        self.items = []
        super.init()
    }
    
    func toJSON() -> JSON? {
        let jsonified = ["name": self.name, "venmoName": self.venmoName!, "profPicURL": self.profPicURL, "paymentComplete": self.paymentComplete, "mealTotal": self.mealTotal] as JSON
        return jsonified
    }
    
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

}
