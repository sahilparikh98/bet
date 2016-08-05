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
    
    var viewsToAnimate: [UIView!]!
    var viewsFinalYPosition : [CGFloat]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UILabel()
        logo.text = "Bet"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Futura", size: 70)
        self.logInView!.logo = logo
        self.logInView!.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.logInView!.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.viewsToAnimate = [self.logInView!.usernameField, self.logInView!.passwordField, self.logInView!.logInButton, self.logInView!.passwordForgottenButton, self.logInView!.facebookButton, self.logInView!.signUpButton, self.logInView!.logo]
        
        self.emailAsUsername = false
        self.signUpController = BetSignUpViewController()
        self.signUpController?.emailAsUsername = self.emailAsUsername
        
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
        self.logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
        self.viewsFinalYPosition = [CGFloat]();
        for viewToAnimate in viewsToAnimate {
            let currentFrame = viewToAnimate.frame
            viewsFinalYPosition.append(currentFrame.origin.y)
            viewToAnimate.frame = CGRectMake(currentFrame.origin.x, self.view.frame.height + currentFrame.origin.y, currentFrame.width, currentFrame.height)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.viewsFinalYPosition.count == self.viewsToAnimate.count {
            UIView.animateWithDuration(1, delay: 0.0, options: .CurveEaseInOut,  animations: { () -> Void in
                for viewToAnimate in self.viewsToAnimate {
                    let currentFrame = viewToAnimate.frame
                    viewToAnimate.frame = CGRectMake(currentFrame.origin.x, self.viewsFinalYPosition.removeAtIndex(0), currentFrame.width, currentFrame.height)
                }
                }, completion: nil)
        }
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
