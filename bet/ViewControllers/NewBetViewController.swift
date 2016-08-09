//
//  NewBetViewController.swift
//  bet
//
//  Created by Apple on 7/22/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import SearchTextField

class NewBetViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var betDescription: UITextView!
    @IBOutlet weak var stakes: UITextField!
    @IBOutlet weak var userBeingBet: SearchTextField!
    var friends = [PFUser]()
    var opponentUser: PFUser?
    var friendship: Friendships?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.betDescription.layer.borderWidth = 1
        self.betDescription.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.betDescription.layer.cornerRadius = 8
        ParseHelper.getUserFriends { (result: [PFObject]?, error: NSError?) -> Void in
            self.friends = result as? [PFUser] ?? []
            let friendsUsernames = self.friends.map { $0.username! }
            self.userBeingBet.filterStrings(friendsUsernames)
        }
        
        /*let friendsQuery = Friendships.query()
        friendsQuery!.whereKey("user", equalTo: PFUser.currentUser()!)
        friendsQuery!.getFirstObjectInBackgroundWithBlock { (result: PFObject?, error: NSError?) -> Void in
            self.friendship = result as? Friendships ?? nil
            let getFriends = self.friendship!.friends.query()
            getFriends.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
                self.friends = result as? [PFUser] ?? []
                let friendsUsernames = self.friends.map { $0.username! }
                self.userBeingBet.filterStrings(friendsUsernames)
            }
        }*/
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
        
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier
        {
            if identifier == "Cancel"
            {
                print("cancel")
            }
            else if identifier == "Save"
            {
                print("save")
                let request = PFObject(className: "BetRequest")
                request["fromUser"] = PFUser.currentUser()!
                for friend in friends
                {
                    //print("\(user.username!)")
                    if friend.username! == self.userBeingBet.text
                    {
                        opponentUser = friend
                    }
                }
                print("\(opponentUser?.username)")
                let bet = Bet()
                bet.betDescription = self.betDescription.text
                bet.creatingUser = PFUser.currentUser()!
                bet.receivingUser = opponentUser!
                bet.forUsers = PFUser.currentUser()!
                bet.againstUsers = opponentUser!
                bet.finished = false
                bet.stakes = self.stakes.text
                bet.accepted = NSNumber.init(bool: false)
                bet.rejected = NSNumber.init(bool: false)
                bet.fromUser = PFUser.currentUser()!
                bet.toUser = opponentUser!
                bet.saveInBackground()
                
                ParseHelper.sendBetRequestNotification(PFUser.currentUser()!, toUser: opponentUser!)
                
                
            }
        }
    }

    //MARK: Actions
    
    
}
