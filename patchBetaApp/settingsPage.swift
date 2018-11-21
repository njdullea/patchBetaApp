//
//  settingsPage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 11/2/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import UIKit
import AWSMobileClient

class settingsPage: UIViewController {
    
    @IBAction func signoutButtonPress(_ sender: Any) {
        
        AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
            //self.showSignIn()
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            // print("Sign-out Successful: \(signInProvider.getDisplayName)");
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
    }
}
