//
//  Bet.swift
//  bet
//
//  Created by Apple on 7/22/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

class Bet : PFObject, PFSubclassing {
    
    //MARK: Fields
    @NSManaged var betDescription: String?
    @NSManaged var creatingUser: PFUser?
    @NSManaged var receivingUser: PFUser?
    @NSManaged var stakes: String?
    @NSManaged var finished: NSNumber?
    @NSManaged var forUsers: PFUser?
    @NSManaged var againstUsers: PFUser?
    
    
    static func parseClassName() -> String {
        return "Bet"
    }
    

}
