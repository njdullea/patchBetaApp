//
//  optionsPage.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/10/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

//import Foundation
import UIKit

class optionsPage: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Options"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

