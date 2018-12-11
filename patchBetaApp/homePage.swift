//
//  homePage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 11/8/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit
//import AWSAuthCore
//import AWSAuthUI
import AWSDynamoDB
import AWSMobileClient

class homePage: UIViewController {
    
    @IBOutlet weak var pillCounter: UILabel!
    
    @objc private func updatePillCounter() {
        switchCount += 1
    }
    
    var switchCount: Int = 0 {
        didSet {
            //make a dispatch queue for this?
            
            //switchPressedLabel.text = "\(switchCount)"
            DispatchQueue.main.async { () -> Void in
                //self.bleStatusLabel.text = "central manager updates"
                self.pillCounter.text = "\(self.switchCount)"
            }
        }
    }
    
    /*
    func queryPillsTaken() {
        print("querying for pills taken")
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = [
            "#userId" : "userId",
        ]
        
        queryExpression.expressionAttributeValues = [
            ":userId" : AWSIdentityManager.default().identityId!,
        ]
        queryExpression.limit = 2
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        
        dynamoDbObjectMapper.query(CapNotifications.self, expression: queryExpression) { (output : AWSDynamoDBPaginatedOutput?, error: Error?) in
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
                    //let capNote = info as? CapNotifications
                    DispatchQueue.main.async {
                        //Do stuff to screen here
                    }
                }
            }
            else {
                print("output is nil")
            }
        }
    }
    */
    
    override func viewDidLoad() {
        
        if shared_BLE_Manager.bleOn == true {
            print("ble is on (homepage)")
        }
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePillCounter), name: Notification.Name("pillTaken"), object: nil)
        
        //queryPillsTaken()
        //print("Uers Name Home PAge")
        //print(AWSIdentityManager.default().identityId!)
        
    }
    
    //TESTING IF THIS WORKS PROPERLY BY CHECKING 'usersName' IN EXT ADHERENCE PAGE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "expAdherenceSegue") {
            let vc = segue.destination as! extAdherencePage
            vc.usersName = AWSIdentityManager.default().identityId!
        }
    }
    
}

