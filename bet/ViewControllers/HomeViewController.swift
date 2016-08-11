//
//  HomeViewController.swift
//  bet
//
//  Created by Apple on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import Bond
import ConvenienceKit
import DCPullRefresh

class HomeViewController: UIViewController {

    //MARK: IB Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    
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
        
        self.tableView.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.getFeedData()
        /*self.getFriends!.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
            self.friends = result as? [PFUser] ?? []
            self.tableView.reloadData()
        }*/
        //MARK: Pull to refresh 
        self.tableView.dcRefreshControl = DCRefreshControl {
            self.getFeedData()
            self.tableView.reloadData()
        }
    }
    
    func getFeedData()
    {
        ParseHelper.getUserBets { (result: [PFObject]?, error: NSError?) -> Void in
            self.userBets = result as? [Bet] ?? []
            print("\(self.userBets.count) number of user bets in getFeedData method")
            self.userBets.sortInPlace{
                $0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedDescending
            }
            self.tableView.reloadData()
        }
        let friendsQuery = Friendships.query()
        friendsQuery!.whereKey("user", equalTo: PFUser.currentUser()!)
        ParseHelper.getUserFriendshipObject { (result: PFObject?, error: NSError?) -> Void in
            self.friendship = result as? Friendships ?? nil
            if self.friendship != nil
            {
                ParseHelper.getFriends(self.friendship!) { (result: [PFObject]?, error: NSError?) -> Void in
                    self.friends = result as? [PFUser] ?? []
                    ParseHelper.getNonFriendBets { (result: [PFObject]?, error: NSError?) -> Void in
                        self.bets = result as? [Bet] ?? []
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
                        self.userBets.sortInPlace{
                            $0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedDescending
                        }
                        print("\(self.userBets.count) number of user bets in getFeedData method after adding friend's bets")
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func userClickOnAccept() {
        getFeedData()
        self.tableView.reloadData()
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
            else if identifier == "displayYourBet"
            {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let bet = userBets[indexPath.row]
                let yourBetViewController = segue.destinationViewController as! YourBetViewController
                yourBetViewController.bet = bet
            }
            else if identifier == "displayFriendBet"
            {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let bet = userBets[indexPath.row]
                
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue)
    {
        
    }
    

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userBets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bet = userBets[indexPath.row]
        print("\(bet.creatingUser!.username!) created the bet, the current user is \(PFUser.currentUser()!.username!)")
        if bet.creatingUser!.username! == PFUser.currentUser()!.username!
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyBetCell", forIndexPath: indexPath) as! MyBetTableViewCell
            cell.usersInvolved.text = "You vs. \(bet.receivingUser!.username!) this is a my bet"
            cell.betDescription.text = "\(bet.betDescription!)"
            cell.timestamp.text = bet.createdAt!.convertToString()
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendBetCell", forIndexPath: indexPath) as! FriendBetTableViewCell
            cell.usersInvolved.text = "\(bet.creatingUser!.username!) vs. \(bet.receivingUser!.username!) this is a friend bet"
            cell.betDescription.text = "\(bet.betDescription!)"
            return cell
        }
    }
    
    
    
    
    
    
    
    
    
    
}
