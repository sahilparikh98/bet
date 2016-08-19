//
//  MyBetsViewController.swift
//  bet
//
//  Created by Apple on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse
import SwiftSpinner
class MyBetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var myBets: [Bet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(refreshControl)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.getFeedData()
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl)
    {
        self.getFeedData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getFeedData()
    {
        SwiftSpinner.show("Loading...")
        ParseHelper.getUserBets { (result: [PFObject]?, error: NSError?) -> Void in
            self.myBets = result as? [Bet] ?? []
            SwiftSpinner.hide()
        }
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
                let controller = segue.destinationViewController as! YourBetViewController
                let indexPath = self.tableView.indexPathForSelectedRow!
                let bet = self.myBets[indexPath.row]
                controller.bet = bet
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

extension MyBetsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myBets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bet = self.myBets[indexPath.row]
        if bet.creatingUser!.username! == PFUser.currentUser()!.username!
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalBetCell", forIndexPath: indexPath) as! ManageBetTableViewCell
            cell.friendLabel.text = bet.receivingUser!.username!
            let image = ParseHelper.getProfilePicture(bet.receivingUser!)
            cell.friendProfilePic.image = image
            let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
            cell.yourProfilePicture.image = yourImage
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalBetCell", forIndexPath: indexPath) as! ManageBetTableViewCell
            cell.friendLabel.text = bet.creatingUser!.username!
            let image = ParseHelper.getProfilePicture(bet.creatingUser!)
            cell.friendProfilePic.image = image
            let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
            cell.yourProfilePicture.image = yourImage
            //image setup
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(self.myBets.count == 0)
        {
            let noDataLabel = UILabel(frame: CGRectMake(0,0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.text = "You have no bets. Create one now!"
            noDataLabel.textColor = UIColor.lightGrayColor()
            noDataLabel.textAlignment = .Center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .None
            return 0
        }
        else
        {
            self.tableView.backgroundView = nil
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
