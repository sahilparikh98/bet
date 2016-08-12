//
//  FriendsViewController.swift
//  bet
//
//  Created by Apple on 8/3/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
class FriendsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [PFUser] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    //Mark: Refresh Control Declaration
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        self.getFriendData()
        self.tableView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAcceptedFriendRequest", name: "userAcceptedFriendRequest", object: nil)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        // Do any additional setup after loading the view.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl)
    {
        self.getFriendData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getFriendData()
    {
        ParseHelper.getUserFriends { (result: [PFObject]?, error: NSError?) -> Void in
            self.friends = result as? [PFUser] ?? []
        }

    }
    
    func userAcceptedFriendRequest()
    {
        self.getFriendData()
        self.tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension FriendsViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell
        cell.friendLabel.text = friend.username!
        let image = ParseHelper.getProfilePicture(friend)
        cell.friendProfilePic.image = image
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(self.friends.count == 0)
        {
            let noDataLabel = UILabel(frame: CGRectMake(0,0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.text = "You have no friends. Add one now!"
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
}