//  THIS IS A BLE MANAGAR SINGLETON IMPLEMENTATION
//  bleManager.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 10/30/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import AWSDynamoDB
import AWSMobileClient

let pill_service = CBUUID(string: "6c251c91-dde0-4263-a0a7-d26b4a662b41")
let pill_schedule_charac = CBUUID(string: "ffc7b3e7-3ff6-4672-a060-a47b884f38b1")
let pill_administered_charac  = CBUUID(string: "3b712824-9972-4283-946b-7257f760b29c")

let shared_BLE_Manager = BLE_Manager.sharedBLE

/*
var switchCount: Int = 0 {
    didSet {
        //make a dispatch queue for this?
        
        //switchPressedLabel.text = "\(switchCount)"
        DispatchQueue.main.async { () -> Void in
            //self.bleStatusLabel.text = "central manager updates"
            //switchPressedLabel.text = "\(self.switchCount)"
        }
    }
}
 */

class BLE_Manager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @objc dynamic var bleOn = false
    @objc dynamic var bleConnected = false
    
    //Singleton
    static let sharedBLE = BLE_Manager()
    
    var centralManager: CBCentralManager?
    var peripheralDevice: CBPeripheral?
    
    //Preventing BLE_Manager initializer from being called elsewhere
    private override init() {
        super.init()
        //Create a queue for the central
        let centralQueue: DispatchQueue = DispatchQueue(label: "doesLabelMatter?", attributes: .concurrent)
        //Create a central to scan for and manage peripherals
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Bluetooth Status is unknown.")
        case .resetting:
            print("Bluetooth Status is resetting.")
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
            self.bleOn = false
            NotificationCenter.default.post(name: Notification.Name("bleOn"), object: nil)
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            self.bleOn = true
            NotificationCenter.default.post(name: Notification.Name("bleOn"), object: nil)
            
            
            /*DispatchQueue.main.async { () -> Void in
                //self.bleStatusLabel.text = "central manager updates"
            }*/
            
            centralManager?.scanForPeripherals(withServices: [pill_service])
            print("scanning...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(peripheral.name!)
        decodePeripheralState(peripheralState: peripheral.state)
        peripheralDevice = peripheral
        peripheralDevice?.delegate = self
        centralManager?.stopScan()
        centralManager?.connect(peripheralDevice!)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        DispatchQueue.main.async { () -> Void in
            //self.bleStatusLabel.text = "peripheral connected"
        }
        peripheralDevice?.discoverServices([pill_service])
        bleConnected = true
        NotificationCenter.default.post(name: Notification.Name("bleConnection"), object: nil)
        print("ble did connect")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            if service.uuid == pill_service {
                //print("Service : \(service)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics! {
            if characteristic.uuid == pill_schedule_charac {
                //let data = lightOn.data(using: String.Encoding.utf8)
                //peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
                //WRITE VALUE OF SCHEDULE
            }
            
            //GET NOTIFIED OF WHEN PILL IS TAKEN
            if characteristic.uuid == pill_administered_charac {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic.uuid == pill_schedule_charac {
            //print success updating schedule
        }
        
        if characteristic.uuid == pill_administered_charac {
            //save data to backend
            NotificationCenter.default.post(name: Notification.Name("pillTaken"), object: nil)
            print("pill taken!")
            
            sendPillTakenData()
            
        }
    }
    
    private func sendPillTakenData() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let capNote: CapNotifications = CapNotifications()
        capNote._userId = AWSIdentityManager.default().identityId
        capNote._dateTime = String(NSDate().timeIntervalSince1970)
        capNote._capStatus = "inPlace"
        capNote._pillTaken = "1"

        //let patInfo: PatientInfo = PatientInfo()
        //patInfo._userId = AWSIdentityManager.default().identityId
        //patInfo._name = name.text
        //patInfo._role = role.text
        //patInfo._schedule = schedule.text
        //patInfo._trial = trial.text
        
        dynamoDbObjectMapper.save(capNote, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A Pill Taken item was saved.")
            //self.findRoleThenSegue()
        })
    }
    /*
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic.uuid == pill_schedule_charac {
            //print success updating schedule
        }
        
        if characteristic.uuid == pill_administered_charac {
            //Save data to backend
        }
    }
    */
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        centralManager?.scanForPeripherals(withServices: [pill_service])
        
        bleConnected = false
        
        NotificationCenter.default.post(name: Notification.Name("bleConnection"), object: nil)
        print("ble disconnected!!")
    }
    
    func decodePeripheralState(peripheralState: CBPeripheralState) {
        
        switch peripheralState {
        case .disconnected:
            print("Peripheral state: disconnected")
        case .connected:
            print("Peripheral state: connected")
        case .connecting:
            print("Peripheral state: connecting")
        case .disconnecting:
            print("Peripheral state: disconnecting")
        }
    }
}
