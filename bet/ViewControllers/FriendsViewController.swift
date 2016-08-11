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
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAcceptedFriendRequest", name: "userAcceptedFriendRequest", object: nil)
        
        self.tableView.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.view.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.tableView.dcRefreshControl = DCRefreshControl {
            self.getFriendData()
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
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
        self.tableView.reloadData()

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
}