//
//  HomeFeedTableViewController.swift
//  bet
//
//  Created by Apple on 8/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit
import Foundation
import DCPullRefresh

class HomeFeedTableViewController: UITableViewController {

    //MARK: Projects
    let defaultRange = 0...4
    let additionalRangeSize = 5
    var userBets: [Bet] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var friendBets: [Bet] = []
    var friendship: Friendships?
    var friends: [PFUser] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var getFriends: PFQuery?
    var bets: [Bet] = []
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userClickOnAccept", name: "userClickOnAccept", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAcceptedResult", name: "userAcceptedResult", object: nil)
        self.getFeedData()
        /*self.getFriends!.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
         self.friends = result as? [PFUser] ?? []
         self.tableView.reloadData()
         }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getFeedData()
    {
        ParseHelper.getUserBets { (result: [PFObject]?, error: NSError?) -> Void in
            self.userBets = result as? [Bet] ?? []
            print("\(self.userBets.count)")
            self.tableView.reloadData()
        }
        let friendsQuery = Friendships.query()
        friendsQuery!.whereKey("user", equalTo: PFUser.currentUser()!)
        ParseHelper.getUserFriendshipObject { (result: PFObject?, error: NSError?) -> Void in
            self.friendship = result as? Friendships ?? nil
            if self.friendship != nil
            {
                ParseHelper.getFriends(self.friendship!) { (results: [PFObject]?, error: NSError?) -> Void in
                    self.friends = results as? [PFUser] ?? []
                    ParseHelper.getNonFriendBets { (resultss: [PFObject]?, error: NSError?) -> Void in
                        self.bets = resultss as? [Bet] ?? []
                        for bet in self.bets
                        {
                            for friend in self.friends
                            {
                                if friend.username! == bet.creatingUser!.username!
                                {
                                    self.userBets.append(bet)
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                let newFriendships = Friendships()
                newFriendships.user = PFUser.currentUser()!
                newFriendships.saveInBackground()
            }
        }
    }
    //MARK: NS Notification Actions
    
    func userClickOnAccept() {
        getFeedData()
        self.tableView.reloadData()
    }
    
    func userAcceptedResult() {
        self.getFeedData()
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userBets.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bet = userBets[indexPath.row]
        if bet.creatingUser!.username! == PFUser.currentUser()!.username!
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("SelfCell", forIndexPath: indexPath) as! SelfFeedTableViewCell
            cell.receivingUser.text = bet.receivingUser!.username!
            let image = ParseHelper.getProfilePicture(bet.receivingUser!)
            cell.receivingUserProfilePic.image = image
            let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
            cell.yourProfilePic.image = yourImage
            return cell
        }
        else if bet.receivingUser!.username! == PFUser.currentUser()!.username!
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("SelfCell", forIndexPath: indexPath) as! SelfFeedTableViewCell
            cell.receivingUser.text = bet.creatingUser!.username!
            let image = ParseHelper.getProfilePicture(bet.creatingUser!)
            cell.receivingUserProfilePic.image = image
            let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
            cell.yourProfilePic.image = yourImage
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! HomeFeedTableViewCell
            cell.creatingUserLabel.text = bet.creatingUser!.username!
            let image = ParseHelper.getProfilePicture(bet.creatingUser!)
            cell.creatingUserProfilePic.image = image
            cell.receivingUserLabel.text = bet.receivingUser!.username!
            let otherImage = ParseHelper.getProfilePicture(bet.receivingUser!)
            cell.receivingUserProfilePic.image = otherImage
            return cell
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
        if let identifier = segue.identifier
        {
            if identifier == "createBet"
            {
                print("creatingBet")
            }
            else if identifier == "displayFriendBet"
            {
                let indexPath = tableView.indexPathForSelectedRow!
                let bet = self.userBets[indexPath.row]
                let controller = segue.destinationViewController as! FriendBetViewController
                controller.bet = bet
            }
            else if identifier == "displayYourBet"
            {
                let indexPath = tableView.indexPathForSelectedRow!
                let bet = self.userBets[indexPath.row]
                let controller = segue.destinationViewController as! YourBetViewController
                controller.bet = bet
            }
        }
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToHomeFeedViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    

}
