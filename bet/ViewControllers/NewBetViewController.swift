//
//  NewBetViewController.swift
//  bet
//
//  Created by Apple on 7/22/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class NewBetViewController: UIViewController {

    @IBOutlet weak var userToBet: UITextField!
    @IBOutlet weak var betDescription: UITextView!
    @IBOutlet weak var stakes: UITextField!
    var users = [PFUser]()
    var opponentUser: PFUser?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.betDescription.layer.borderWidth = 1
        self.betDescription.layer.borderColor = UIColor.grayColor().CGColor
        self.betDescription.layer.cornerRadius = 8
        let query = PFUser.query()!
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) -> Void in
            self.users = result as? [PFUser] ?? []
        }
        
        
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
                for user in users
                {
                    //print("\(user.username!)")
                    if user.username! == self.userToBet.text
                    {
                        opponentUser = user;
                    }
                }
                print("\(opponentUser?.username)")
                let bet = Bet()
                bet.betDescription = self.betDescription.text
                bet.creatingUser = PFUser.currentUser()!
                bet.receivingUser = opponentUser
                bet.forUsers = PFUser.currentUser()!
                bet.againstUsers = opponentUser!
                bet.finished = false
                bet.stakes = self.stakes.text
                bet.accepted = NSNumber.init(bool: false)
                bet.rejected = NSNumber.init(bool: false)
                bet.fromUser = PFUser.currentUser()!
                bet.toUser = opponentUser!
                bet.saveInBackground()
                let otherBet = Bet()
                otherBet.betDescription = self.betDescription.text
                otherBet.creatingUser = opponentUser
                otherBet.forUsers = opponentUser!
                otherBet.againstUsers = PFUser.currentUser()!
                otherBet.receivingUser = PFUser.currentUser()!
                otherBet.stakes = self.stakes.text
                otherBet.accepted = NSNumber.init(bool: false)
                otherBet.rejected = NSNumber.init(bool: false)
                bet.fromUser = opponentUser!
                bet.toUser = PFUser.currentUser()!
                otherBet.saveInBackground()
                let friendRequest = FriendRequest()
                friendRequest.creatingUser = opponentUser!
                friendRequest.receivingUser = PFUser.currentUser()!
                friendRequest.fromUser = opponentUser!
                friendRequest.toUser = PFUser.currentUser()!
                friendRequest.accepted = false
                friendRequest.rejected = false
                friendRequest.saveInBackground()
                
                
            }
        }
    }


}
