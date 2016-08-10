//
//  DisplayBetRequestViewController.swift
//  bet
//
//  Created by Apple on 7/26/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class DisplayBetRequestViewController: UIViewController {
    @IBOutlet weak var fromUser: UILabel!
    @IBOutlet weak var betDescription: UITextView!
    @IBOutlet weak var friendProfilePic: UIImageView!

    var bet: Bet?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        if let bet = bet
        {
            self.fromUser.text = bet.creatingUser!.username!
            self.betDescription.text = bet.betDescription!
            let image = ParseHelper.getProfilePicture(bet.creatingUser!)
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

}
