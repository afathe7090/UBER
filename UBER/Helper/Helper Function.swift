//
//  Helper Function.swift
//  UBER
//
//  Created by Ahmed Fathy on 01/10/2021.
//

import Foundation


func saveCurrentID(_ value: String?){
    defaults.setValue(value, forKey: kUSERDEFAULTSID)
    defaults.synchronize()
}


func getCurrentID()-> String? {
    return defaults.string(forKey: kUSERDEFAULTSID)
}


func userDictionary(user: User)-> NSDictionary{
    return NSDictionary(objects: [user.email , user.fullName , user.accountType.rawValue], forKeys: [kEMAIL as NSCopying , kFULL_NAME as NSCopying , kACCOUNT_TYPE as NSCopying])
}


