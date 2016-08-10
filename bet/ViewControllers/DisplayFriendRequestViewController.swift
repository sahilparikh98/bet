//
//  DisplayFriendRequestViewController.swift
//  bet
//
//  Created by Apple on 7/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class DisplayFriendRequestViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!

    var friendRequest: FriendRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        // Do any additional setup after loading the view.
        if let friendRequest = friendRequest
        {
            self.nameLabel.text = friendRequest.creatingUser!.username!
            let image = ParseHelper.getProfilePicture(friendRequest.creatingUser!)
            self.profilePicture.image = image

        }
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
