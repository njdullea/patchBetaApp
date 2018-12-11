//
//  profilePage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 11/8/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileClient

class profilePage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var trialLabel: UILabel!
   
    //MARK: When button is pressed, logout out, segue to login page, set user Role as nil
    @IBAction func logoutButton(_ sender: Any) {
        //userRole = nil
        AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
            //self.showSignIn()
            self.performSegue(withIdentifier: "profileToLogin", sender: nil)
            // print("Sign-out Successful: \(signInProvider.getDisplayName)");
            
        })
    }
    
    //MARK: Function using AWS DynamoDB to find saved profile details
    func loadUserInfo() {
        print("AWSDB Page find user role")
        let dynamoDbObjectManager = AWSDynamoDBObjectMapper.default()
        let userAttributes: PatientInfo = PatientInfo()
        userAttributes._userId = AWSIdentityManager.default().identityId!
        dynamoDbObjectManager.load(PatientInfo.self, hashKey: userAttributes._userId!, rangeKey: nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let user = task.result as? PatientInfo {
                // Do something with task.result.
                print(user._role!)
                DispatchQueue.main.async {
                    self.nameLabel.text = user._name!
                    self.roleLabel.text = user._role!
                    self.scheduleLabel.text = user._schedule!
                    self.trialLabel.text = user._trial!
                }
            }
            print("finished finding user role")
            return nil
        })
    }
}
