//
//  bleStatus.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 11/2/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import UIKit

class bleStatusPage: UIViewController {
    
    //Not supposed to use IBOutlets immediately for some reason
    
    @IBOutlet weak var bleStatus: UILabel!
    @IBOutlet weak var bleConnected: UILabel!
    
    @objc private func updateBLEStatus() {
        print("updating BLE status text")
        if shared_BLE_Manager.bleOn == true {
            DispatchQueue.main.async { () -> Void in
                self.bleStatus.textColor = UIColor.green
            }
        }
        else {
            DispatchQueue.main.async { () -> Void in
                self.bleStatus.textColor = UIColor.red
            }
        }
    }
    
    @objc private func updateBLEConnectionStatus() {
        print("updating BLE connection text")
        if shared_BLE_Manager.bleConnected == true {
            DispatchQueue.main.async { () -> Void in
                self.bleConnected.textColor = UIColor.green
            }
        }
        else {
            DispatchQueue.main.async { () -> Void in
                self.bleConnected.textColor = UIColor.red
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        if shared_BLE_Manager.bleOn == true {
            self.bleStatus.textColor = UIColor.green
        }
        else {
            self.bleStatus.textColor = UIColor.red
        }
        
        
        if shared_BLE_Manager.bleConnected == true {
            self.bleConnected.textColor = UIColor.green
        }
        else {
            self.bleConnected.textColor = UIColor.red
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBLEStatus), name: Notification.Name("bleOn"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBLEConnectionStatus), name: Notification.Name("bleConnection"), object: nil)
    }
    
}

