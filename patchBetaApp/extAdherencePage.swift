//
//  patHomePage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/7/18.
//  Copyright © 2018 PATCH. All rights reserved.
//
// The class (Extended adherence history) takes a userId and shows the users adherence
// history

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileClient

class extAdherencePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayPills = Array<String>()
    //This might be some other type, need to check it
    //This variable is set by the 'prepare for segue' in the home page
    var usersName: String? = nil
    
    
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
    
    
    func queryPillsTaken(user: String?) {
        print("querying for pills taken")
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = [
            "#userId" : "userId",
        ]
        
        //queryExpression.expressionAttributeValues = [
        //    ":userId" : AWSIdentityManager.default().identityId!,
        //]
        queryExpression.expressionAttributeValues = [
            ":userId" : user!,
        ]
        queryExpression.limit = 5
        queryExpression.scanIndexForward = false
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.query(CapNotifications.self, expression: queryExpression) { (output : AWSDynamoDBPaginatedOutput?, error: Error?) in
            //print("receive stuff back")
            if error != nil {
                //print("The request failed. Error: \(String(describing: error))")
            }
            else {
                //print("no error")
            }
            if output != nil {
                //print("output is not nil")
                //print(output!.items)
                for info in output!.items {
                    let capNote = info as? CapNotifications
                    let timeString = self.capStringToTimeString(capString: capNote!._dateTime!)
                    self.arrayPills.append(timeString)
                    //DispatchQueue.main.async {
                    
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
    
    func capStringToTimeString(capString: String) -> String {
        //Convert string with time since 1970 to NSDate
        let stringAsDouble = Double(capString)
        let doubleAsDateTime = NSDate(timeIntervalSince1970: stringAsDouble!)
        
        //Convert NSDate to actual time and date string
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.medium
        let dateTimeString = formatter.string(from: doubleAsDateTime as Date)
        return dateTimeString
    }
    
    
    override func viewDidLoad() {
        
        if shared_BLE_Manager.bleOn == true {
            print("ble is on (homepage)")
        }
        
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(updatePillCounter), name: Notification.Name("pillTaken"), object: nil)
        
        queryPillsTaken(user:usersName)
        
        /*
        //Testing AWSDBManager
        let testDBMan = AWSDBManager()
        DispatchQueue.main.async {
            testDBMan.findUserRole()
        }
        */
        
        /*
         //Testing the prepare for segue from homePage
         
        */
        //print("User Name")
        //print(usersName!)
 
    }
}


