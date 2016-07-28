//
//  Helper.swift
//  ServiceChat
//
//  Created by Owner on 2016. 7. 24..
//  Copyright © 2016년 TwistWorld. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn

class Helper {
    static let helper = Helper()
    
    func loginAnnonymously() {
        // switch view by setting navigation controller as root view controller
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (anonymousUser, error) in
            if error == nil {
                print("UserId: \(anonymousUser!.uid)")
                self.switchToNavigationViewController()
                
            } else {
                print(error!.localizedDescription)
                return
            }
        })
    }
    
    func logInWithGoogle(authentication: GIDAuthentication) {
        
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                print(user?.email)
                print(user?.displayName)
                
                self.switchToNavigationViewController()
            }
        })
    }
    
    private func switchToNavigationViewController() {
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // From main storyboard instantiate a navigation controller
        let naviVC = storyboard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController
        
        // Get the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Set Navigation Controller as root view controller
        appDelegate.window?.rootViewController = naviVC
    }
}
