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
        
        ParseHelper.getUserFriends { (results: [PFObject]?, error: NSError?) -> Void in
            self.friends = results as? [PFUser] ?? []
            ParseHelper.getAllUsers { (result: [PFObject]?, error: NSError?) -> Void in
                self.allUsers = result as? [PFUser] ?? []
                for user in self.allUsers
                {
                    for friend in self.friends
                    {
                        if user.username! != friend.username!
                        {
                            self.nonFriends.append(user)
                        }
                    }
                }
                self.nonFriendsUsernames = self.nonFriends.map { $0.username! }
                self.friendToAdd.filterStrings(self.nonFriendsUsernames)
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

