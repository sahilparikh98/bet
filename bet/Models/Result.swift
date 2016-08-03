//
//  Result.swift
//  bet
//
//  Created by Apple on 8/1/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
class Result: PFObject, PFSubclassing {

    //MARK: Properties
    @NSManaged var toBet: Bet?
    @NSManaged var winner: PFUser?
    @NSManaged var loser: PFUser?
    @NSManaged var accepted: NSNumber?
    @NSManaged var rejected: NSNumber?
    @NSManaged var fromUser: PFUser?
    @NSManaged var toUser: PFUser?
    @NSManaged var conflict: NSNumber?
    
    //MARK: PFObject Required Methods
    
    static func parseClassName() -> String
    {
        return "Result"
    }
}
