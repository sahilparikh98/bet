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
class MyBetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var myBets: [Bet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let userQuery = Bet.query()
        userQuery!.whereKey("creatingUser", equalTo: PFUser.currentUser()!)
        userQuery!.whereKey("finished", equalTo: false)
        userQuery!.whereKey("accepted", equalTo: true)
        userQuery!.whereKey("rejected", equalTo: false)
        userQuery!.includeKey("creatingUser")
        userQuery!.includeKey("receivingUser")
        userQuery!.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
            self.myBets = result as? [Bet] ?? []
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
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

extension MyBetsViewController: UITableViewDataSource
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
//            let image = ParseHelper.getProfilePicture(bet.receivingUser!)
//            cell.friendProfilePic.image = image
//            let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
//            cell.yourProfilePicture.image = yourImage
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalBetCell", forIndexPath: indexPath) as! ManageBetTableViewCell
            cell.friendLabel.text = bet.creatingUser!.username!
//            let image = ParseHelper.getProfilePicture(bet.creatingUser!)
//            cell.friendProfilePic.image = image
//            let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
//            cell.yourProfilePicture.image = yourImage
            //image setup
            return cell
        }
    }
}
