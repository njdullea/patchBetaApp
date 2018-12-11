//
//  loginPage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 11/2/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSDynamoDB
import AWSMobileClient

var userRole : String?

class loginPage: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
        }
        else {
            self.findRoleThenSegue()
            //self.performSegue(withIdentifier: "loginToPatient", sender: nil)
            //self.performSegue(withIdentifier: "loginToResearcher", sender: nil)
        }
    }
    
    
    
    func presentAuthUIViewController() {
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.backgroundColor = UIColor.white
        config.isBackgroundColorFullScreen = true
        config.logoImage = UIImage(named: "miniLogo180")
        
        AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
                    // SignIn succeeded.
                    self.findRoleThenSegue()
                    //self.performSegue(withIdentifier: "loginToPatient", sender: nil)
                    //self.performSegue(withIdentifier: "loginToResearcher", sender: nil)
                } else {
                    // end user faced error while loggin in, take any required action here.
                }
        })
    }
    
    
    func findRoleThenSegue() {
        print("findRoleThenSegue")
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = [
            "#userId" : "userId",
        ]
        
        queryExpression.expressionAttributeValues = [
            ":userId" : AWSIdentityManager.default().identityId!,
        ]
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.query(PatientInfo.self, expression: queryExpression) { (output : AWSDynamoDBPaginatedOutput?, error: Error?) in
            
            print("receive stuff back")
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            else {
                print("no error")
            }
            if output != nil {
                //print("output is not nil")
                //print(output!.items)
                //If output!.items == [] segue to finishProfile
                var count = 0
                
                for info in output!.items {
                    count = count + 1
                    let patInformation = info as? PatientInfo
                    //print("patient name")
                    //print("\(patInformation!._role!)")
                    self.segueToRole(patInfo: patInformation!)
                    return
                }
 
                if count == 0 {
                    print("segue to finishProfile")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "finishProfileSegue", sender: nil)
                    }
                }
            }
            else {
                print("output is nil")
            }
        }
    }
    
    
    
    func segueToRole(patInfo: PatientInfo) {
        print("segueToRole")

        if patInfo._role == "patient" {
            print("Role is patient")
            userRole = "patient"
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginToPatient", sender: nil)
            }
        }
        else if patInfo._role == "researcher" {
            print("Role is researcher")
            userRole = "researcher"
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginToResearcher", sender: nil)
            }
        }
    }
    
    


    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
