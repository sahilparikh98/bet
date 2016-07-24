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
}
