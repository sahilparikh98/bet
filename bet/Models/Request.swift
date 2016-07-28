//
//  Request.swift
//  bet
//
//  Created by Apple on 7/25/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
protocol Request {
    
    var fromUser: PFUser? {get set}
    var toUser: PFUser? {get set}
    


}



