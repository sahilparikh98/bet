//
//  BetSignUpViewController.swift
//  bet
//
//  Created by Apple on 8/5/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import ParseUI
import Parse
class BetSignUpViewController: PFSignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UILabel()
        logo.text = "Bet"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Futura", size: 70)
        self.signUpView
        self.signUpView!.logo = logo
        self.signUpView!.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRectMake(logoFrame.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, signUpView!.frame.width,  logoFrame.height)
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
