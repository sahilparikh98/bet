//
//  MyProfileViewController.swift
//  bet
//
//  Created by Apple on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
class MyProfileViewController: UIViewController {
    //MARK: IB outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var yourProfilePic: UIImageView!
    @IBOutlet weak var lossesLabel: UILabel!
    var parseLoginHelper: ParseLoginHelper!
    //MARK: Properties
    
    //MARK: UI Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.76, green:0.26, blue:0.25, alpha:1.0)
        self.nameLabel.text = PFUser.currentUser()!.username!
        let image = ParseHelper.getProfilePicture(PFUser.currentUser()!)
        self.yourProfilePic.image = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logOutUser(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Confirm log out", message: "Are you sure you want to log out", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .Destructive, handler: { (action: UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
                let installation = PFInstallation.currentInstallation()!
                installation.removeObjectForKey("user")
                installation.saveInBackground()
                self.loginSetup()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in 
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginSetup()
    {
            
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
                // Initialize the ParseLoginHelper with a callback
            if let error = error {
                    // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                    // if login was successful, display the TabBarController
                    // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
                    // 3
                self.presentViewController(tabBarController, animated:true, completion:nil)
                let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                appDelegate?.window?.rootViewController = tabBarController
            }
        }
        let loginViewController = BetLoginViewController()
        loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
        loginViewController.delegate = parseLoginHelper
        loginViewController.emailAsUsername = false
        
        loginViewController.signUpController?.delegate = parseLoginHelper
        loginViewController.signUpController?.emailAsUsername = loginViewController.emailAsUsername
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
        
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
