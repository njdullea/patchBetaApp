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
    
    
    var arrayPatients = Array<String?>()
    var arrayPatientsIDs = Array<String?>()
    var selectedUser : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //arrayPatients.append("Hello")
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
        print(indexPath)
        print(indexPath[1])
        self.selectedUser = indexPath[1]
        performSegue(withIdentifier: "resToExtAdherence", sender: self)
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
                    print(patient._userId!)
                    let usersID = patient._userId
                    let usersName = patient._name
                    self.arrayPatients.append(usersName)
                    self.arrayPatientsIDs.append(usersID)
                }
            }
            DispatchQueue.main.async {
                self.resHomeTable.reloadData()
            }
            return()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "resToExtAdherence") {
            let vc = segue.destination as! extAdherencePage
            vc.usersName = self.arrayPatientsIDs[self.selectedUser!]
        }
    }
}
