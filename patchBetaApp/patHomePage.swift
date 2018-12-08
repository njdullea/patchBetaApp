//
//  patHomePage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/7/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit
//import AWSAuthCore
//import AWSAuthUI
import AWSDynamoDB
import AWSMobileClient

class patHomePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayPills = Array<String>()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPills.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = arrayPills[indexPath.row]
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
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
        queryExpression.limit = 5
        
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
                    let capNote = info as? CapNotifications
                    self.arrayPills.append(capNote!._dateTime!)
                    //DispatchQueue.main.async {
                        //Do stuff to screen here
                        //self.tableView.reloadData()
                        //self.tableView.reloadData()
                    //}
                }
                DispatchQueue.main.async {
                //Do stuff to screen here
                    self.tableView.reloadData()
                }
            }
            else {
                print("output is nil")
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        if shared_BLE_Manager.bleOn == true {
            print("ble is on (homepage)")
        }
        
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(updatePillCounter), name: Notification.Name("pillTaken"), object: nil)
        
        queryPillsTaken()
        
        //Testing AWSDBManager
        let testDBMan = AWSDBManager()
        DispatchQueue.main.async {
            testDBMan.findUserRole()
        }
        //testDBMan.findUserRole()
        
    }
}
