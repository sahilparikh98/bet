//
//  AddFriendsViewController.swift
//  bet
//
//  Created by Apple on 8/3/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SearchTextField
import Parse
class AddFriendsViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var friendToAdd: SearchTextField!
    var allUsers: [PFUser] = []
    var nonFriends: [PFUser] = []
    var nonFriendsUsernames: [String] = []
    var friends: [PFUser] = []
    var friendRequest: FriendRequest?
    var userToAdd: PFUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.friendToAdd.theme.font = UIFont.systemFontOfSize(14)
        self.friendToAdd.theme.cellHeight = 30
        ParseHelper.getUserFriends { (results: [PFObject]?, error: NSError?) -> Void in
            self.friends = results as? [PFUser] ?? []
            ParseHelper.getAllUsers { (result: [PFObject]?, error: NSError?) -> Void in
                self.allUsers = result as? [PFUser] ?? []
                for user in self.allUsers
                {
                    if self.friends.count != 0
                    {
                        for friend in self.friends
                        {
                            if user.username! != friend.username!
                            {
                                self.nonFriends.append(user)
                            }
                        }
                        self.nonFriendsUsernames = self.nonFriends.map { $0.username! }
                        self.friendToAdd.filterStrings(self.nonFriendsUsernames)
                    }
                    else
                    {
                        self.nonFriendsUsernames = self.allUsers.map { $0.username! }
                        self.friendToAdd.filterStrings(self.nonFriendsUsernames)
                    }
                }
                
            }
        }
    // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        if self.friendToAdd.text?.characters.count == 0
        {
            //alert the user that there is nothing entered
            let alert = UIAlertController(title: "No username entered", message: "Please enter a username", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action: UIAlertAction) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
        }
        else
        {
            ParseHelper.getUserByUsername(self.friendToAdd.text!) { (result: PFObject?, error: NSError?) -> Void in
                self.userToAdd = result as? PFUser ?? nil
                if self.userToAdd != nil
                {
                    ParseHelper.checkExistingFriendRequest(PFUser.currentUser()!, toUser: self.userToAdd!) { (resultObject: PFObject?, error: NSError?) -> Void in
                        let existingFriendRequest = resultObject as? FriendRequest ?? nil
                        if existingFriendRequest == nil
                        {
                            self.friendRequest = FriendRequest()
                            self.friendRequest!.accepted = false
                            self.friendRequest!.rejected = false
                            self.friendRequest!.creatingUser = PFUser.currentUser()!
                            self.friendRequest!.receivingUser = self.userToAdd!
                            self.friendRequest!.saveInBackground()
                            
                            let pushQuery = PFInstallation.query()!
                            pushQuery.whereKey("user", equalTo: self.userToAdd!)
                            let data = ["alert" : "Friend request from \(self.userToAdd!.username!)", "badge" : "Increment"]
                            let push = PFPush()
                            push.setData(data)
                            push.sendPushInBackground()
                            
                            let confirmationAlert = UIAlertController(title: "Request sent", message: "Friend request has been sent", preferredStyle: UIAlertControllerStyle.Alert)
                            confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                                confirmationAlert.navigationController?.popToRootViewControllerAnimated(true)
                            }))
                            self.presentViewController(confirmationAlert, animated: true, completion: nil)
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Request already sent", message: "You have already sent a request to this user.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                                alert.dismissViewControllerAnimated(true, completion: nil)
                            }))
                        }
                    }
                        
                }
            }
        }
        
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


