//
//  ResultRequestViewController.swift
//  bet
//
//  Created by Apple on 8/2/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class ResultRequestViewController: UIViewController {

    @IBOutlet weak var friendProfilePic: UIImageView!
    @IBOutlet weak var usersInvolved: UILabel!
    @IBOutlet weak var betDescription: UITextView!
    var bet: Bet?
    var result: Result?
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if let result = result
        {
            if result.fromUser!.username! == result.winner!.username!
            {
                self.usersInvolved.text = "\(result.fromUser!.username!) has won the bet!"
            }
            else
            {
                self.usersInvolved.text = "\(result.fromUser!.username!) has lost the bet!"
            }
            
            self.betDescription.text = result.toBet!.betDescription!
            let image = ParseHelper.getProfilePicture(result.fromUser!)
            self.friendProfilePic.image = image
            
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
    
    @IBAction func userAcceptsResult(sender: AnyObject) {
        if let bet = bet
        {
            if let result = result
            {
                bet.finished = true
                result.accepted = true
                result.saveInBackground()
                bet.saveInBackground()
                        
            }
        }
    }
    
//    @IBAction func userAcceptsResult(sender: UIButton)
//    {
//        if let bet = bet
//        {
//            if let result = result
//            {
//                bet.finished = true
//                result.accepted = true
//                result.saveInBackground()
//                bet.saveInBackground()
//                
//            }
//        }
//    }
    
//    @IBAction func userRejectsResult(sender: UIButton)
//    {
//        if let bet = bet
//        {
//            if let result = result
//            {
//                let rejectAlert = UIAlertController(title: "Are you sure you want to reject this result?", message: "This will cause a conflicted bet that will show up in your user profile.", preferredStyle: UIAlertControllerStyle.Alert)
//                rejectAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler:{ (action: UIAlertAction) in
//                    rejectAlert.dismissViewControllerAnimated(true, completion: nil)
//                    result.accepted = false
//                    result.rejected = true
//                    result.conflict = true
//                    bet.finished = true
//                    bet.saveInBackground()
//                    result.saveInBackground()
//                    
//                }))
//                rejectAlert.addAction(UIAlertAction(title: "No", style: .Default, handler:{ (action: UIAlertAction) in
//                    rejectAlert.dismissViewControllerAnimated(true, completion: nil)
//                }))
//                presentViewController(rejectAlert, animated: true, completion: nil)
//            }
//        }
//    }
    @IBAction func userRejectsResult(sender: AnyObject) {
        if let result = result
        {
            let rejectAlert = UIAlertController(title: "Are you sure you want to reject this result?", message: "This will cause a conflicted bet that will show up in your user profile.", preferredStyle: UIAlertControllerStyle.Alert)
            rejectAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler:{ (action: UIAlertAction) in
                rejectAlert.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("rejectResultRequest", sender: self)
//                result.accepted = false
//                result.rejected = true
//                result.conflict = true
//                result.toBet!.finished = true
//                result.toBet!.saveInBackground()
//                result.saveInBackground()
                
            }))
            rejectAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{ (action: UIAlertAction) in
                rejectAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(rejectAlert, animated: true, completion: nil)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "rejectResultRequest"
        {
            var rejected = false
            let rejectAlert = UIAlertController(title: "Are you sure you want to reject this result?", message: "This will cause a conflicted bet that will show up in your user profile.", preferredStyle: UIAlertControllerStyle.Alert)
            rejectAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler:{ (action: UIAlertAction) in
                rejectAlert.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("userRejectedResult", object: nil)
                self.performSegueWithIdentifier("rejectResultRequest", sender: self)
                rejected = true
                
            }))
            rejectAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{ (action: UIAlertAction) in
                rejectAlert.dismissViewControllerAnimated(true, completion: nil)
                rejected = false
            }))
            presentViewController(rejectAlert, animated: true, completion: nil)
            return rejected
        }
        else
        {
            return true
        }
    }
    
}
