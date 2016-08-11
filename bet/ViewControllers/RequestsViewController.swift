
//
//  RequestsViewController.swift
//  bet
//
//  Created by Apple on 7/25/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import Foundation
import Bond

class RequestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var betRequests: [Bet] = []
    var allRequests: [PFObject] = []
        {
        didSet {
            self.tableView.reloadData()
        }
    }
    var friendRequests: [FriendRequest] = []
    var resultRequests: [Result] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        ParseHelper.getUserBetRequests { (result: [PFObject]?, error: NSError?) -> Void in
            self.betRequests = result as? [Bet] ?? []
            for request in self.betRequests
            {
                self.allRequests.append(request)
            }
            self.tableView.reloadData()
        }
        
        ParseHelper.getUserFriendRequests { (result: [PFObject]?, error: NSError?) -> Void in
            self.friendRequests = result as? [FriendRequest] ?? []
            for request in self.friendRequests
            {
                self.allRequests.append(request)
            }
            self.tableView.reloadData()
        }
        
        let resultQuery = Result.query()
        resultQuery!.whereKey("toUser", equalTo: PFUser.currentUser()!)
        resultQuery!.whereKey("rejected", equalTo: false)
        resultQuery!.whereKey("accepted", equalTo: false)
        resultQuery!.includeKey("toUser")
        resultQuery!.includeKey("fromUser")
        resultQuery!.includeKey("winner")
        resultQuery!.includeKey("loser")
        resultQuery!.includeKey("toBet")
        resultQuery!.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
            self.resultRequests = result as? [Result] ?? []
            for resultRequest in self.resultRequests
            {
                self.allRequests.append(resultRequest)
            }
            self.tableView.reloadData()
        }
        self.tableView.dcRefreshControl = DCRefreshControl {
            self.viewDidLoad()
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if let identifier = segue.identifier
        {
            if identifier == "displayBetRequest"
            {
                let indexPath = tableView.indexPathForSelectedRow!
                
                let bet = allRequests[indexPath.row] as! Bet
                
                let displayBetRequestViewController = segue.destinationViewController as! DisplayBetRequestViewController
                displayBetRequestViewController.bet = bet
            }
            else if identifier == "displayFriendRequest"
            {
                let indexPath = tableView.indexPathForSelectedRow!
                let friendRequest = allRequests[indexPath.row] as! FriendRequest
                let displayFriendRequestViewController = segue.destinationViewController as! DisplayFriendRequestViewController
                displayFriendRequestViewController.friendRequest = friendRequest
            }
            else if identifier == "displayResultRequest"
            {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let result = self.allRequests[indexPath.row] as! Result
                let controller = segue.destinationViewController as! ResultRequestViewController
                controller.result = result
            }
        }
        
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToRequestsViewController(segue: UIStoryboardSegue)
    {
        self.tableView.reloadData()
        if let identifier = segue.identifier
        {
            if identifier == "reject"
            {
                let displayBetRequestViewController = segue.sourceViewController as! DisplayBetRequestViewController
                let noLongerRequest = displayBetRequestViewController.bet! as PFObject!
                displayBetRequestViewController.bet!.accepted = false
                displayBetRequestViewController.bet!.rejected = true
                displayBetRequestViewController.bet!.saveInBackgroundWithBlock { (bool: Bool, error: NSError?) in
                    self.allRequests = self.allRequests.filter { $0 !== noLongerRequest }
                    self.betRequests = self.betRequests.filter { $0 !== noLongerRequest }
                    self.tableView.reloadData()
                }
                
            }
            else if identifier == "accept"
            {
                let displayBetRequestViewController = segue.sourceViewController as! DisplayBetRequestViewController
                let noLongerRequest = displayBetRequestViewController.bet! as PFObject!
                displayBetRequestViewController.bet!.rejected = false
                displayBetRequestViewController.bet!.accepted = true
                
                displayBetRequestViewController.bet!.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) in
                    print("bet accepted")
                    NSNotificationCenter.defaultCenter().postNotificationName("userClickOnAccept", object: nil)
                    self.allRequests =  self.allRequests.filter { $0 !== noLongerRequest }
                    self.betRequests =  self.betRequests.filter { $0 !== noLongerRequest }
                    self.tableView.reloadData()
                    
                })
                
            }
            else if identifier == "acceptFriendRequest"
            {
                let displayFriendRequestController = segue.sourceViewController as! DisplayFriendRequestViewController
                let noLongerRequest = displayFriendRequestController.friendRequest! as PFObject
                displayFriendRequestController.friendRequest!.accepted = true
                displayFriendRequestController.friendRequest!.rejected = false
                displayFriendRequestController.friendRequest!.saveInBackground()
                displayFriendRequestController.friendRequest!.saveInBackgroundWithBlock ({ (bool: Bool, error: NSError?) in
                    ParseHelper.getUserFriendshipObject { (resultOne: PFObject?, error: NSError?) -> Void in
                        let friendship = resultOne as? Friendships ?? nil
                        friendship!.friends.addObject(displayFriendRequestController.friendRequest!.creatingUser!)
                        friendship!.saveInBackgroundWithBlock( {(bool: Bool, error: NSError?) in
                            NSNotificationCenter.defaultCenter().postNotificationName("userAcceptedFriendRequest", object: nil)
                            self.allRequests = self.allRequests.filter { $0 !== noLongerRequest }
                            self.betRequests = self.betRequests.filter { $0 !== noLongerRequest }
                            self.tableView.reloadData()
                        })
                    }
                })
                let backFriendship = Friendships()
                backFriendship.friends.addObject(PFUser.currentUser()!)
                backFriendship.user = displayFriendRequestController.friendRequest!.creatingUser!
                backFriendship.saveInBackground()
                displayFriendRequestController.friendRequest!.creatingUser!.saveInBackground()
                self.tableView.reloadData()
            }
            else if identifier == "rejectFriendRequest"
            {
                let displayFriendRequestController = segue.sourceViewController as! DisplayFriendRequestViewController
                let noLongerRequest = displayFriendRequestController.friendRequest! as PFObject
                displayFriendRequestController.friendRequest!.accepted = false
                displayFriendRequestController.friendRequest!.rejected = true
                displayFriendRequestController.friendRequest!.saveInBackgroundWithBlock({(bool: Bool, error: NSError?) in
                    self.allRequests = self.allRequests.filter { $0 !== noLongerRequest }
                    self.tableView.reloadData()
                })
            }
            else if identifier == "acceptResultRequest"
            {
                let controller = segue.sourceViewController as! ResultRequestViewController
                let noLongerRequest = controller.result! as PFObject
                controller.result!.accepted = true
                controller.result!.rejected = false
                controller.result!.toBet!.finished = true
                controller.result!.saveInBackgroundWithBlock({(bool: Bool, error: NSError?) in
                    self.allRequests = self.allRequests.filter { $0 !== noLongerRequest }
                    self.tableView.reloadData()
                    controller.result!.toBet!.saveInBackgroundWithBlock({(bool: Bool, error: NSError?) in
                        NSNotificationCenter.defaultCenter().postNotificationName("userAcceptedResult", object: nil)
                    })
                })
                
            }
            else if identifier == "rejectResultRequest"
            {
                let controller = segue.sourceViewController as! ResultRequestViewController
                let noLongerRequest = controller.result! as PFObject
                controller.result!.accepted = false
                controller.result!.rejected = true
                controller.result!.toBet!.finished = true
                controller.result!.saveInBackground()
                controller.result!.toBet!.saveInBackground()
                self.allRequests.filter { $0 !== noLongerRequest }
            }
        }
    }
    
        
        
    
    

}

extension RequestsViewController: UITableViewDataSource
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allRequests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let fromRequest = self.allRequests[indexPath.row]
        
        if fromRequest is FriendRequest
        {
            let request = fromRequest as! FriendRequest
            print("\(request.receivingUser!.username!)")
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendRequestCell", forIndexPath: indexPath) as! FriendRequestTableViewCell
            
            cell.friendRequestLabel.text = "Friend request from \(request.creatingUser!.username!)"
            return cell
        }
        else if fromRequest is Bet
        {
            let request = fromRequest as! Bet
            let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath) as! RequestTableViewCell
            cell.requestType.text = "Bet request from \(request.creatingUser!.username!)"
            return cell
        }
        else
        {
            let request = fromRequest as! Result
            let cell = tableView.dequeueReusableCellWithIdentifier("ResultRequestCell", forIndexPath: indexPath) as! ResultRequestTableViewCell
            cell.usersInvolved.text = "Result from \(request.fromUser!.username!) needs approval"
            return cell
        }
        
        //let cell = indexPath.row % 2 == 0 ? tableView.dequeueReusableCellWithIdentifier("BetRequestCell", forIndexPath: indexPath) : tableView.dequeueReusableCellWithIdentifier("FriendRequestCell", forIndexPath: indexPath)
        
        //cell.textLabel!.text = indexPath.row % 2 == 0 ? "Bet" : "Friend"
        
        // cell.requestLabel.text! = "\(allRequests[indexPath.section][indexPath.row].parseClassName) request from \(allRequests[indexPath.section][indexPath.row].creatingUser!.username)"
        
        //return cell
    }
}







