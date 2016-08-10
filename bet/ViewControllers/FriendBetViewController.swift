//
//  FriendBetViewController.swift
//  bet
//
//  Created by Apple on 8/9/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class FriendBetViewController: UIViewController {
    
    @IBOutlet weak var creatingUserLabel: UILabel!
    @IBOutlet weak var creatingUserProfilePic: UIImageView!
    
    @IBOutlet weak var receivingUserLabel: UILabel!
    @IBOutlet weak var receivingUserProfilePic: UIImageView!
    
    var bet: Bet?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bet = bet
        {
            self.creatingUserLabel.text = bet.creatingUser!.username!
            self.receivingUserLabel.text = bet.receivingUser!.username!
            let image = ParseHelper.getProfilePicture(bet.creatingUser!)
            self.creatingUserProfilePic.image = image
            let otherImage = ParseHelper.getProfilePicture(bet.receivingUser!)
            self.receivingUserProfilePic.image = otherImage
        }
        self.view.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reportBet(sender: AnyObject) {
        let alert = UIAlertController(title: "Report inappropriate content", message: "Are you sure you would like to report this bet as inappropriate?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Report", style: .Destructive, handler: { (action: UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            let confirmation = UIAlertController(title: "Bet reported", message: "The report for inappropriate content is being reviewed.", preferredStyle: UIAlertControllerStyle.Alert)
            confirmation.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                confirmation.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            self.presentViewController(confirmation, animated: true, completion: nil)
        }))
        presentViewController(alert, animated: true, completion: nil)
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
