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

    @IBOutlet weak var yourProfilePic: UIImageView!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var friendProfilePic: UIImageView!
    @IBOutlet weak var betDescription: UITextView!

    var bet: Bet?
    var opponent: PFUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        if let bet = bet
        {
            if bet.creatingUser!.username! == PFUser.currentUser()!.username!
            {
                self.opponent = self.bet!.receivingUser
                self.friendLabel.text = opponent!.username!
                let image = ParseHelper.getProfilePicture(bet.receivingUser!)
                self.friendProfilePic.image = image
                let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
                self.yourProfilePic.image = yourImage
                
                //image set up
            }
            else
            {
                self.opponent = self.bet!.creatingUser!
                self.friendLabel.text = opponent!.username!
                let image = ParseHelper.getProfilePicture(bet.creatingUser!)
                self.friendProfilePic.image = image
                let yourImage = ParseHelper.getProfilePicture(PFUser.currentUser()!)
                self.yourProfilePic.image = yourImage
                //image set up
            }
            self.betDescription.font = UIFont.systemFontOfSize(17)
            self.betDescription.text = "\(self.bet!.betDescription!)"
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
                    result.fromUser = PFUser.currentUser()!
                    result.toUser = self.opponent!
                    result.accepted = false
                    result.rejected = false
                    result.toBet = self.bet!
                    result.toBet!.resultSubmitted = true
                    result.senderName = PFUser.currentUser()!.username!
                    result.receiverName = PFUser.currentUser()!.username!
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
                    result.fromUser = PFUser.currentUser()!
                    result.toUser = self.opponent!
                    result.accepted = false
                    result.rejected = false
                    result.toBet = self.bet!
                    result.toBet!.resultSubmitted = true
                    result.senderName = PFUser.currentUser()!.username!
                    result.saveInBackground()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }))
                presentViewController(confirmationAlert, animated: true, completion: nil)
            }
        }
    }
    

}
