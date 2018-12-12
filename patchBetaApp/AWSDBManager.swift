//
//  AWSDBManager.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/7/18.
//  Copyright © 2018 PATCH. All rights reserved.
//
//  This class manages storing, and retrieving information from the
//  tables hosted in the DB in AWS mobile hub.

//THIS FILE IS CURRENTLY UNUSED BY ANYTHING

import Foundation
import AWSMobileClient
import AWSDynamoDB



class AWSDBManager: NSObject {
 
    /*
    //Both patient and researcher use this to find proper segues
    func returnUserRole() {
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
                /*
                switch user._role {
                case "Patient":
                    return Role.Patient
                case "Researcher":
                    return Role.Researcher
                case .none:
                    return nil
                case .some(_):
                    return nil
                }
                */
            }
            print("finished finding user role")
            return nil
        })
    }
    
    //Used after profile creation
    func postProfileDetails() {
        
    }
    */
    
    //Patient will use this method when
    func postCapNotification(userId: String, dateTime: String, capStatus: String, pillTaken:String) -> Bool {
        return true
    }
    
    
    func queryPillsTaken(userID: String, numPills: Int? = nil) -> [CapNotifications] {
        let listed = [CapNotifications]()
        return listed
    }
    
    //Researcher will use this to list patients. If no trial parameter passed, then list all patients
    func queryPatientsEnrolled(trial: Int? = nil) -> [PatientInfo] {
        let listed = [PatientInfo]()
        return listed
    }
}
