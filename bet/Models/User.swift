//
//  User.swift
//  bet
//
//  Created by Apple on 7/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
class User: PFUser {

    @NSManaged var profilePicture: PFFile?
    @NSManaged var friends: PFObject?
    
}
