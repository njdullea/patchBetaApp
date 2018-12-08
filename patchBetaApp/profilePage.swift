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
        queryInfo()
    }

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var schedule: UITextField!
    @IBOutlet weak var trialName: UITextField!
    
   
    @IBAction func sendInfo(_ sender: Any) {
        //queryInfo()
        //sendPatInfo(sender)
    }
    
    func queryInfo() {
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
                    DispatchQueue.main.async {
                        self.name.text = patInfo!._name!
                        self.role.text = patInfo!._role!
                        self.trialName.text = patInfo!._trial
                        self.schedule.text = patInfo!._schedule
                    }
                }
            }
            else {
                print("output is nil")
            }
        }
    }
}
