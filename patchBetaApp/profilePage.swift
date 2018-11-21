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

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var schedule: UITextField!
    @IBOutlet weak var trialName: UITextField!
    
   
    @IBAction func sendInfo(_ sender: Any) {
        //queryInfo(sender)
        sendPatInfo(sender)
    }
    
    func sendPatInfo(_ sender:Any) {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        let patInfo: PatientInfo = PatientInfo()
        patInfo._userId = AWSIdentityManager.default().identityId
        //patInfo._name = String(name.text!)
        //patInfo._role = String(role.text!)
        //patInfo._schedule = String(schedule.text!)
        //patInfo._trial = String(trialName.text!)
        patInfo._name = "pat One"
        patInfo._role = "patient"
        patInfo._schedule = "01:00"
        patInfo._trial = "01"
        
        dynamoDbObjectMapper.save(patInfo, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
    }
    
    func queryInfo(_ sender:Any) {
        print("Query Info")
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
                for info in output!.items {
                    let patInfo = info as? PatientInfo
                    print("patient name")
                    print("\(patInfo!._name!)")
                }
            }
            else {
                print("output is nil")
            }
        }
    }
}
