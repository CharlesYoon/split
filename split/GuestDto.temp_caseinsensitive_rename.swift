//
//  GuestDto.swift
//  split
//
//  Created by Brandon Taleisnik on 7/11/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import Foundation
import Gloss

class GuestDto {
    var name: String?
    var userID: Int?
    var venmoName: String?
    var profPicURL: String?
    
    required init?(json: JSON) {
        self.name = "name" <~~ json
        self.userID = "userID" <~~ json
        self.venmoName = "venmoName" <~~ json
        self.profPicURL = "profPicURL" <~~ json
    }
    
    init() {
        self.name = ""
        self.userID = nil
        self.venmoName = ""
        self.profPicURL = ""
    }
    
    init(name: String?, userID: Int?, venmoName: String?, profPicURL: String?) {
        self.name = name
        self.userID = userID
        self.venmoName = venmoName
        self.profPicURL = profPicURL
    }
    
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as? String
        self.userID = dictionary["userID"] as? Int
        self.venmoName = dictionary["venmoName"] as? String
        self.profPicURL = dictionary["profPicURL"] as? String
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "name" ~~> self.name,
            "userID" ~~> self.userID,
            "venmoName" ~~> self.venmoName,
            "profPicURL" ~~> self.profPicURL
            ])
    }
}
