//
//  sideBar.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 11/8/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

import Foundation
import UIKit

class sideBar: UIViewController {
    @IBAction func segueHome(_ sender: Any) {
        if userRole == "patient" {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "sidebarToPatient", sender: nil)
            }
        }
        else if userRole == "researcher" {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "sidebarToResearcher", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
