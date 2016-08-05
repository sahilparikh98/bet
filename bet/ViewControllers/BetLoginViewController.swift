//
//  BetLoginViewController.swift
//  bet
//
//  Created by Apple on 8/4/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import ParseUI
import Parse
class BetLoginViewController: PFLogInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UILabel()
        logo.text = "Bet"
        logo.textColor = UIColor.redColor()
        logo.font = UIFont(name: "Futura", size: 70)
        self.logInView!.logo = logo
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
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
