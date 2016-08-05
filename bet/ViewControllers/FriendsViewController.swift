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
        ParseHelper.getUserFriends { (result: [PFObject]?, error: NSError?) -> Void in
            self.friends = result as? [PFUser] ?? []
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return cell
    }
}