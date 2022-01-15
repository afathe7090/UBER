//
//  UserModel.swift
//  UserModel
//
//  Created by Ahmed Fathy on 07/09/2021.
//

import UIKit
import CoreLocation


enum AccountType: Int{
    case passenger
    case driver
}

struct User{
    let email: String
    let fullName: String
    var accountType: AccountType!
    var location: CLLocation?
    var uid: String?
    
    
    init(uid: String,dictionary: [String: Any]){
        self.uid = uid
        self.fullName = dictionary[kFULL_NAME] as? String ?? ""
        self.email = dictionary[kEMAIL] as? String ?? ""
        
        if let index = dictionary[kACCOUNT_TYPE] as? Int{
            self.accountType = AccountType(rawValue: index)
        }        
    }
    
    init(email: String , fullName: String , accountType: Int){
        
        self.email = email
        self.fullName = fullName
        self.accountType = AccountType(rawValue: accountType)
    }
    
}

