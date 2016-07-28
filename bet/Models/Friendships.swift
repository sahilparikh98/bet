//
//  Friendships.swift
//  bet
//
//  Created by Apple on 7/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
class Friendships: PFObject, PFSubclassing {

    var friends: PFRelation {
        return relationForKey("friends")
    }
    
    
    static func parseClassName() -> String {
        return "Friendships"
    }
}
