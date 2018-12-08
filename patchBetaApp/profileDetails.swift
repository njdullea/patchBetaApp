//
//  profileDetails.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 11/20/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileClient

class profileDetails: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var role: UITextField!
    
    @IBOutlet weak var schedule: UITextField!
    
    @IBOutlet weak var trial: UITextField!
    
    @IBAction func finishDetails(_ sender: Any) {
        self.sendDetails()
    }
    
    func sendDetails() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        let patInfo: PatientInfo = PatientInfo()
        patInfo._userId = AWSIdentityManager.default().identityId
        patInfo._name = name.text
        patInfo._role = role.text
        patInfo._schedule = schedule.text
        patInfo._trial = trial.text
        
        dynamoDbObjectMapper.save(patInfo, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
            self.findRoleThenSegue()
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
                print("output is not nil")
                print(output!.items)
                //If output!.items == [] segue to finishProfile
                var count = 0
                
                for info in output!.items {
                    count = count + 1
                    let patInformation = info as? PatientInfo
                    print("patient name")
                    print("\(patInformation!._role!)")
                    self.segueToRole(patInfo: patInformation!)
                    return
                }
                
                if count == 0 {
                    print("data wasnt saved :(")
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
                self.performSegue(withIdentifier: "detailsToPatient", sender: nil)
            }
        }
        else if patInfo._role == "researcher" {
            print("Role is researcher")
            userRole = "researcher"
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "detailsToResearcher", sender: nil)
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
