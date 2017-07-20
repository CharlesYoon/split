//
//  ItemDTO.swift
//  split
//
//  Created by Charles Yoon on 7/20/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON
import SwiftyJSONRealmObject

class ItemDTO: Object {
    dynamic var name: String?
    dynamic var price: Double
    dynamic var isAssigned: Bool
    dynamic var itemID: String? = ""
    
    required init() {
        self.name = ""
        self.price = 0.0
        self.isAssigned = false
        super.init()
    }
    
    init(name: String?, price: Double?, itemID: String? = nil) {
        self.name = name
        self.price = price!
        self.isAssigned = false
        self.itemID = itemID
        super.init()
    }
    
    init(dictionary: [String: AnyObject], key: String? = nil) {
        self.name = dictionary["name"] as? String
        self.price = (dictionary["price"] as? Double)!
        self.isAssigned = (dictionary["isAssigned"] as? Bool)!
        self.itemID = key
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    func toJSON() -> JSON? {
        let jsonified = ["name": self.name, "price": self.price, "isAssigned": self.isAssigned] as JSON
        return jsonified
    }
    
    required init?(json: JSON) {
        self.name = json["name"].stringValue
        self.price = json["price"].doubleValue
        self.isAssigned = json["isAssigned"].boolValue
        self.itemID = json["itemID"].stringValue
        super.init()
    }
    
}
