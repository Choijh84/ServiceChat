//
//  LogInViewController.swift
//  ServiceChat
//
//  Created by Owner on 2016. 7. 24..
//  Copyright © 2016년 TwistWorld. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LogInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
    @IBOutlet var anonymousButton: UIButton!
    
    @IBAction func loginAnnonymouslyDidTapped(sender: AnyObject) {
        // switch view by setting navigation controller as root view controller
        Helper.helper.loginAnnonymously()
    }
    
    @IBAction func googleLoginDidTapped(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            print(error!.localizedDescription)
        } else {
            print(user.authentication)
            Helper.helper.logInWithGoogle(user.authentication)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // anonymousButton;
        // Set border color and width
        anonymousButton.layer.borderWidth = 2.0
        anonymousButton.layer.borderColor = UIColor.whiteColor().CGColor
        anonymousButton.layer.cornerRadius = 7.0
        GIDSignIn.sharedInstance().clientID = "407114344547-3aubmmrtkugg34cqrti9a758q447i87q.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

}
