//
//  YourBetViewController.swift
//  bet
//
//  Created by Apple on 8/1/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
class YourBetViewController: UIViewController {

    @IBOutlet weak var usersInvolved: UILabel!
    @IBOutlet weak var betDescription: UILabel!
    @IBOutlet weak var terms: UILabel!
    @NSManaged var bet: Bet?
    @NSManaged var opponent: PFUser?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if bet != nil
        {
            if self.bet!.creatingUser!.username! == PFUser.currentUser()!.username
            {
                self.opponent = self.bet!.receivingUser
                self.usersInvolved!.text = "You vs. \(opponent!.username!)"
            }
            else
            {
                self.opponent = self.bet!.creatingUser!
                self.usersInvolved!.text = "You vs. \(opponent!.username!)"
            }
            self.betDescription.text = "\(self.bet!.betDescription!)"
            self.terms.text = "\(self.bet!.stakes!)"
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: Actions
    
    @IBAction func userLostBet(sender: UIButton)
    {
        let confirmationAlert = UIAlertController(title: "Are you sure?", message: "You have lost this bet. Is this correct?", preferredStyle: UIAlertControllerStyle.Alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            confirmationAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
            let result = Result()
            result.winner = self.opponent!
            result.loser = PFUser.currentUser()!
            result.accepted = false
            result.rejected = false
            result.saveInBackground()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        
    }
    
    
    @IBAction func userWonBet(sender: UIButton)
    {
        let confirmationAlert = UIAlertController(title: "Are you sure?", message: "You have won this bet. Is this correct?", preferredStyle: UIAlertControllerStyle.Alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            confirmationAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
            let result = Result()
            result.winner = PFUser.currentUser()!
            result.loser = self.opponent!
            result.accepted = false
            result.rejected = false
            result.saveInBackground()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        
        
    }
    

}
