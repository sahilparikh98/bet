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
            print("\(self.myBets.count) on the my bets controller")
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
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalBetCell", forIndexPath: indexPath) as! PersonalBetsTableViewCell
            cell.usersInvolved.text = "Your bet with \(bet.receivingUser!.username!)"
            cell.betDescription.text = bet.betDescription!
            cell.timestamp.text = bet.createdAt!.convertToString()
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalBetCell", forIndexPath: indexPath) as! PersonalBetsTableViewCell
            cell.usersInvolved.text = "Your bet with \(bet.creatingUser!.username!)"
            cell.betDescription.text = bet.betDescription!
            cell.timestamp.text = bet.createdAt!.convertToString()
            return cell
        }
    }
}
