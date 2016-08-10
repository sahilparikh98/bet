//
//  ParseHelper.swift
//  bet
//
//  Created by Apple on 7/22/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse
import UIKit

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
    
    static func getUserBets(completionBlock: PFQueryArrayResultBlock)
    {
        let userQuery = Bet.query()
        userQuery!.whereKey("creatingUser", equalTo: PFUser.currentUser()!)
        userQuery!.whereKey("finished", equalTo: false)
        userQuery!.whereKey("accepted", equalTo: true)
        userQuery!.whereKey("rejected", equalTo: false)
        userQuery!.includeKey("creatingUser")
        userQuery!.includeKey("receivingUser")
        userQuery!.findObjectsInBackgroundWithBlock(completionBlock)
        
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
    
    static func getUserFriends(completionBlock: PFQueryArrayResultBlock)
    {
        let query = Friendships.query()
        query!.whereKey("user", equalTo: PFUser.currentUser()!)
        query!.getFirstObjectInBackgroundWithBlock { (result: PFObject?, error: NSError?) -> Void in
            let friendship = result as? Friendships ?? nil
            if let friendship = friendship
            {
                let getFriends = friendship.friends.query()
                getFriends.findObjectsInBackgroundWithBlock(completionBlock)
            }
            else
            {
                let newFriendship = Friendships()
                newFriendship.user = PFUser.currentUser()
                let getFriends = newFriendship.friends.query()
                getFriends.findObjectsInBackgroundWithBlock(completionBlock)
            }
        }
    }
    
    static func getAllUsers(completionBlock: PFQueryArrayResultBlock) -> PFQuery
    {
        let query = PFUser.query()
        query!.whereKey(ParseHelper.ParseUserUsername, notEqualTo: PFUser.currentUser()!.username!)
        query!.orderByAscending(ParseHelper.ParseUserUsername)
        query!.findObjectsInBackgroundWithBlock(completionBlock)
        return query!
    }
    
    static func searchUsers(searchText: String, completionBlock: PFQueryArrayResultBlock) -> PFQuery
    {
        let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername, matchesRegex: searchText, modifiers: "i")
        query.whereKey(ParseHelper.ParseUserUsername, notEqualTo: PFUser.currentUser()!.username!)
        
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
        
    }
    
    static func getNonFriendUsers(user: PFUser, completionBlock: PFQueryArrayResultBlock)
    {
        let query = Friendships.query()
        query!.whereKey("user", equalTo: PFUser.currentUser()!)
        query!.getFirstObjectInBackgroundWithBlock { (result: PFObject?, error: NSError?) -> Void in
            let friendship = result as? Friendships ?? nil
            let getFriends = friendship!.friends.query()
            getFriends.findObjectsInBackgroundWithBlock(completionBlock)
            
        }
    }
    
    
    static func sendFriendRequest(fromUser: PFUser, toUser: PFUser)
    {
        let request = FriendRequest()
        request.creatingUser = fromUser
        request.receivingUser = toUser
        request.accepted = false
        request.rejected = false
        request.saveInBackground()
    }
    
    static func removeFriend(fromUser: PFUser, toUser: PFUser)
    {
        let query = Friendships.query()!
        query.whereKey("user", equalTo: fromUser)
        query.getFirstObjectInBackgroundWithBlock { (result: PFObject?, error: NSError?) -> Void in
            let friendship = result as? Friendships ?? nil
            let friendQuery = friendship!.friends.query()
            friendQuery.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
                let friends = results ?? []
                for friend in friends
                {
                    if friend == toUser
                    {
                        friend.deleteInBackground()
                    }
                }
            }
              
        }
    }
    
    static func checkExistingFriendRequest(fromUser: PFUser, toUser: PFUser, completionBlock: PFObjectResultBlock)
    {
        let query = FriendRequest.query()!
        query.whereKey("creatingUser", equalTo: fromUser)
        query.whereKey("receivingUser", equalTo: toUser)
        query.whereKey("accepted", equalTo: false)
        query.whereKey("rejected", equalTo: false)
        query.getFirstObjectInBackgroundWithBlock(completionBlock)
        
    }
    
    static func getUserByUsername(username: String, completionBlock: PFObjectResultBlock)
    {
        let query = PFUser.query()!
        query.whereKey("username", equalTo: username)
        query.getFirstObjectInBackgroundWithBlock(completionBlock)
    }
    
    static func getUserFriendshipObject(completionBlock: PFObjectResultBlock)
    {
        let query = Friendships.query()!
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.getFirstObjectInBackgroundWithBlock(completionBlock)
    }
    
    static func sendBetRequestNotification(fromUser: PFUser, toUser: PFUser)
    {
        let pushQuery = PFInstallation.query()!
        pushQuery.whereKey("user", equalTo: toUser)
        let data = ["alert" : "New bet request from \(fromUser.username!)!", "badge" : "Increment"]
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(data)
        push.sendPushInBackground()
    }
    
    static func getNonFriendBets(completionBlock: PFQueryArrayResultBlock)
    {
        let betsFromFriends = Bet.query()
        betsFromFriends!.whereKey("accepted", equalTo: true)
        betsFromFriends!.whereKey("rejected", equalTo: false)
        betsFromFriends!.whereKey("finished", equalTo: false)
        betsFromFriends!.includeKey("creatingUser")
        betsFromFriends!.includeKey("receivingUser")
        betsFromFriends!.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func getFriends(friendship: Friendships, completionBlock: PFQueryArrayResultBlock)
    {
        let query = friendship.friends.query()
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
//    static func getProfilePicture(user: PFUser) -> UIImage
//    {
//        do {
//            let data = try user.objectForKey("profilePicture")?.getData()
//            let image = UIImage(data: data!, scale: 1.0)
//            return image!
//        }
//        catch {
//            print("no image, setting default image")
//            let image = UIImage(named: "download")
//            return image!
//            
//        }
//    }
    
    
    
    
    
    
    
}