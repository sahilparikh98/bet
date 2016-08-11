//
//  ParseLoginHelper.swift
//  Makestagram
//
//  Created by Benjamin Encz on 4/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Parse
import ParseUI

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/**
 This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
 it will call the callback function and provide a 'PFUser' object.
 */
class ParseLoginHelper : NSObject {
    static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
    static let usernameNotFoundErrorCode = 1
    static let usernameNotFoundLocalizedDescription = "Could not retrieve Facebook username"
    
    let callback: ParseLoginHelperCallback
    
    init(callback: ParseLoginHelperCallback) {
        self.callback = callback
    }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        // Determine if this is a Facebook login
        let isFacebookLogin = FBSDKAccessToken.currentAccessToken() != nil
        
        if !isFacebookLogin {
            // Plain parse login, we can return user immediately
            self.callback(user, nil)
        } else {
            // if this is a Facebook login, fetch the username from Facebook
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler {
                (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
                if let error = error {
                    // Facebook Error? -> hand error to callback
                    self.callback(nil, error)
                }
                
                if let fbUsername = result?["name"] as? String {
                    // assign Facebook name to PFUser
                    var userId: String = ""
                    if result != nil
                    {
                        userId = (result?["id"] as? String)!
                    }
                    user.username = fbUsername
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        
                        // Get Facebook profile picture
                        let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                        
                        let profilePictureUrl = NSURL(string: userProfile)
                        
                        let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                        
                        if(profilePictureData != nil)
                        {
                            let profileFileObject = PFFile(data:profilePictureData!)
                            user.setObject(profileFileObject!, forKey: "profilePicture")
                        }
                    }
                    // store PFUser
                    user.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if (success) {
                            // updated username could be stored -> call success
                            self.callback(user, error)
                        } else {
                            // updating username failed -> hand error to callback
                            self.callback(nil, error)
                        }
                    })
                } else {
                    // cannot retrieve username? -> create error and hand it to callback
                    //                    let userInfo = [NSLocalizedDescriptionKey : ParseLoginHelper.usernameNotFoundLocalizedDescription]
                    //                    let noUsernameError = NSError(
                    //                        domain: ParseLoginHelper.errorDomain,
                    //                        code: ParseLoginHelper.usernameNotFoundErrorCode,
                    //                        userInfo: userInfo
                    //                    )
                    self.callback(nil, error)
                }
            }
        }
    }
    
}

extension ParseLoginHelper : PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.callback(user, nil)
    }
    
}

