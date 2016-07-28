//
//  ParseHelper.swift
//  bet
//
//  Created by Apple on 7/22/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

public class ParseHelper
{
    static let ParseUserUsername = "username"
    
    static func getUsers(completionBlock: PFQueryArrayResultBlock) -> PFQuery
    {
        return PFUser.query()!
    }
    
    static func getUserBetRequests(completionBlock: PFQueryArrayResultBlock)
    {
        let query = Bet.query()
        query!.whereKey("accepted", equalTo: false)
        query!.whereKey("rejected", equalTo: false)
        query!.whereKey("receivingUser", equalTo: PFUser.currentUser()!)
        query!.includeKey("creatingUser")
        query!.includeKey("receivingUser")
        query!.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func getUserFriendRequests(completionBlock: PFQueryArrayResultBlock)
    {
        let friendRequestQuery = FriendRequest.query()
        friendRequestQuery!.whereKey("accepted", equalTo: false)
        friendRequestQuery!.whereKey("rejected", equalTo: false)
        friendRequestQuery!.whereKey("receivingUser", equalTo: PFUser.currentUser()!)
        friendRequestQuery!.includeKey("creatingUser")
        friendRequestQuery!.includeKey("receivingUser")
        friendRequestQuery!.findObjectsInBackgroundWithBlock(completionBlock)
    }
}