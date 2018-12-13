//
//  resHomePage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/11/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileClient

class resHomePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resHomeTable: UITableView!
    
    
    var arrayPatients = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayPatients.append("Hello")
        self.queryPatients()
    }
    
    ///////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = arrayPatients[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //IT IS WORKING AND GETTING THE PATIENTS :)
    func queryPatients() {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "#role = :role"
        scanExpression.expressionAttributeNames = ["#role" : "role"]
        scanExpression.expressionAttributeValues = [":role": "patient"]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.scan(PatientInfo.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for patient in paginatedOutput.items as! [PatientInfo] {
                    // Do something with book.
                    print(patient)
                }
            }
            return()
        })
    }
    ///////////////////
}
