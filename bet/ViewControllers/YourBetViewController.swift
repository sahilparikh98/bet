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
    var bet: Bet?
    var opponent: PFUser?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let bet = bet
        {
            if bet.creatingUser!.username! == PFUser.currentUser()!.username
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
        if let bet = bet
        {
            if bet.resultSubmitted == true
            {
                let noResultAlert = UIAlertController(title: "A result has already been submitted for this bet", message: "Please check your requests.", preferredStyle: UIAlertControllerStyle.Alert)
                noResultAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
                    noResultAlert.dismissViewControllerAnimated(true, completion: nil)
                }))
                presentViewController(noResultAlert, animated: true, completion: nil)
            }
            else
            {
                let confirmationAlert = UIAlertController(title: "Are you sure?", message: "You have lost this bet. Is this correct?", preferredStyle: UIAlertControllerStyle.Alert)
                confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
                    confirmationAlert.dismissViewControllerAnimated(true, completion: nil)
                }))
                confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
                    let result = Result()
                    result.loser = PFUser.currentUser()!
                    result.winner = self.opponent!
                    result.accepted = false
                    result.rejected = false
                    result.toBet = self.bet!
                    result.saveInBackground()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }))
                presentViewController(confirmationAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func userWonBet(sender: UIButton)
    {
        if let bet = bet
        {
            if bet.resultSubmitted == true
            {
                let noResultAlert = UIAlertController(title: "A result has already been submitted for this bet", message: "Please check your requests.", preferredStyle: UIAlertControllerStyle.Alert)
                noResultAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
                    noResultAlert.dismissViewControllerAnimated(true, completion: nil)
                }))
                presentViewController(noResultAlert, animated: true, completion: nil)
            }
            else
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
                    result.toBet = self.bet!
                    result.saveInBackground()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }))
                presentViewController(confirmationAlert, animated: true, completion: nil)
            }
        }
    }
    

}
