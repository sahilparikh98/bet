//
//  HomeViewController.swift
//  bet
//
//  Created by Apple on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    var userBets: [Bet] = []
    var friendBets: [Bet] = []
    var friends: [PFUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let userQuery = Bet.query()
        userQuery!.whereKey("creatingUser", equalTo: PFUser.currentUser()!)
        userQuery!.whereKey("finished", equalTo: false)
        userQuery!.whereKey("accepted", equalTo: true)
        userQuery!.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
            self.userBets = result as? [Bet] ?? []
        }
        let friendship = PFUser.currentUser()!.objectForKey("friends") as! Friendships
        let friendsQuery = friendship.friends.query()
        friendsQuery.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
            self.friends = result as? [PFUser] ?? []
            
        }
       // let betsFromFriends = Bet.query()
        //betsFromFriends!.whereKey("creatingUser", matchesKey: )
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier
        {
            if identifier == "createBet"
            {
                print("creating bet")
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue)
    {
        
    }
    

}
