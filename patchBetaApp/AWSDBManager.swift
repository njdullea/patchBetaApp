//
//  AWSDBManager.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/7/18.
//  Copyright © 2018 PATCH. All rights reserved.
//
//  This class manages storing, and retrieving information from the
//  tables hosted in the DB in AWS mobile hub.

import Foundation
import AWSMobileClient
import AWSDynamoDB

class AWSDBManager: NSObject {
    
    
    
    func findUserRole() {
        print("AWSDB Page find user role")
        let dynamoDbObjectManager = AWSDynamoDBObjectMapper.default()
        //var userKey = AWSIdentityManager.default().identityId!
        let userAttributes: PatientInfo = PatientInfo()
        userAttributes._userId = AWSIdentityManager.default().identityId!
        dynamoDbObjectManager.load(PatientInfo.self, hashKey: userAttributes._userId!, rangeKey: nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let user = task.result as? PatientInfo {
                // Do something with task.result.
                print(user)
                print("^ user role")
            }
            print("finished finding user role")
            return nil
        })
    }
    
    /*
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

    */
    
}
