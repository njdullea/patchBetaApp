//
//  patHomePage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/11/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileClient

class patHomePage: UIViewController {
    
    override func viewDidLoad() {
        
        if shared_BLE_Manager.bleOn == true {
            print("ble is on (homepage)")
        }
        
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(updatePillCounter), name: Notification.Name("pillTaken"), object: nil)
        
    }
    
    //TESTING IF THIS WORKS PROPERLY BY CHECKING 'usersName' IN EXT ADHERENCE PAGE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "expAdherenceSegue") {
            let vc = segue.destination as! extAdherencePage
            vc.usersName = AWSIdentityManager.default().identityId!
        }
    }
}

