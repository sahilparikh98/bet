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
import SwiftSpinner

class NewBetViewController: UIViewController, UITextViewDelegate {

    //MARK: Properties
    @IBOutlet weak var betDescription: UITextView!
    @IBOutlet weak var stakes: UITextField!
    @IBOutlet weak var userBeingBet: SearchTextField!
    var allUsers = [PFUser]()
    var friends = [PFUser]()
    var opponentUser: PFUser?
    var friendship: Friendships?
    var noSuchFriend: [String] = ["No such friend."]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.betDescription.delegate = self
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.userBeingBet.theme.font = UIFont.systemFontOfSize(14)
        self.userBeingBet.theme.cellHeight = 30
        self.userBeingBet.highlightAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(14)]
        // Do any additional setup after loading the view.
        self.betDescription.layer.borderWidth = 1
        self.betDescription.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.betDescription.layer.cornerRadius = 8
        self.betDescription.text = "What's the bet? Include the terms!"
        self.betDescription.textColor = UIColor.lightGrayColor()
        
        
        ParseHelper.getUserFriends { (result: [PFObject]?, error: NSError?) -> Void in
            self.friends = result as? [PFUser] ?? []
            let friendsUsernames = self.friends.map { $0.username! }
            self.userBeingBet.filterStrings(friendsUsernames)
        }
        
        
        ParseHelper.getAllUsers { (result: [PFObject]?, error: NSError?) -> Void in
            self.allUsers = result as? [PFUser] ?? []
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

    func searchResults(name: String, usernames: [String]) -> Bool
    {
        var found = false
        for username in usernames
        {
            let numChar = name.characters.count
            if username.characters.count >= numChar
            {
                if name == username.substringToIndex(username.startIndex.advancedBy(numChar))
                {
                    found = true
                }
            }
        }
        return found
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's the bet? Include the terms!"
            textView.textColor = UIColor.lightGrayColor()
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
//                if self.userBeingBet.text!.isEmpty
//                {
//                    let alert = UIAlertController(title: "No user selected", message: "Please select a user.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
//                        alert.dismissViewControllerAnimated(true, completion: nil)
//                    }))
//                }
                
                
                
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        for friend in friends
        {
            
            if friend.username! == self.userBeingBet.text
            {
                opponentUser = friend
            }
        }
        
        if identifier == "saveBetRequest"
        {
            if self.userBeingBet.text!.isEmpty
            {
                let alert = UIAlertController(title: "No user has been selected", message: "Please enter a user", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                return false
            }
            else if self.betDescription.text! == "What's the bet? Include the terms!"
            {
                let alert = UIAlertController(title: "No description", message: "Please enter a description", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                return false
            }
            else if self.opponentUser == nil
            {
                let alert = UIAlertController(title: "User not found", message: "Please enter a user in your friends list.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                return false
            }
            else
            {
                for friend in friends
                {

                    if friend.username! == self.userBeingBet.text
                    {
                        opponentUser = friend
                    }
                }
                let bet = Bet()
                bet.betDescription = self.betDescription.text
                bet.creatingUser = PFUser.currentUser()!
                bet.receivingUser = opponentUser!
                bet.forUsers = PFUser.currentUser()!
                bet.againstUsers = opponentUser!
                bet.finished = false
                bet.accepted = NSNumber.init(bool: false)
                bet.rejected = NSNumber.init(bool: false)
                bet.fromUser = PFUser.currentUser()!
                bet.toUser = opponentUser!
                bet.senderName = PFUser.currentUser()!.username!
                bet.receiverName = opponentUser!.username!
                bet.saveInBackground()
                return true
            }
        }
        return true
        
    }

    

    //MARK: Actions
    
}
