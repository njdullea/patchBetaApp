//
//  Role.swift
//  patchBetaApp
//
//  Created by Nathan Dullea on 12/10/18.
//  Copyright © 2018 PATCH. All rights reserved.
//

//THIS PAGE IS NOT USED RIGHT NOW, BUT WILL BE TO PROMOTE TYPE SAFETY
import Foundation

enum Role {
    case Researcher, Patient
    
    func roleString() -> String {
        switch self {
        case .Researcher:
            return "Researcher"
        case .Patient:
            return "Patient"
        }
    }
}
