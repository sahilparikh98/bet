//
//  BetRequest.swift
//  bet
//
//  Created by Apple on 7/25/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class FriendRequest: PFObject, PFSubclassing, Request {

    @NSManaged var creatingUser: PFUser?
    @NSManaged var receivingUser: PFUser?
    @NSManaged var fromUser: PFUser?
    @NSManaged var toUser: PFUser?
    @NSManaged var accepted: NSNumber?
    @NSManaged var rejected: NSNumber?
    @NSManaged var senderName: String?
    @NSManaged var receiverName: String?
    
    static func parseClassName() -> String
    {
        return "FriendRequest"
    }
}
