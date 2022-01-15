//
//  Constants.swift
//  Constants
//
//  Created by Ahmed Fathy on 08/09/2021.
//

import UIKit
import Firebase

let defaults = UserDefaults.standard

let DB_REF = Database.database().reference()
let REF_USRS = DB_REF.child(kUSERSCHILD)
let REF_DRIVERS_LOCATION = DB_REF.child(kDRIVERSCHILD)
let REF_TRIPS = DB_REF.child(kTRIPES)

let kUSERSCHILD = "Users_Data"
let kUSERDEFAULTSID = "currentUserID"
let kDRIVERSCHILD = "Driver_Data"
let kTRIPES = "trips"
let kFULL_NAME = "fullName"
let kEMAIL = "email"
let kACCOUNT_TYPE = "segmentIndex"
let kPICKUP_COORDINATE = "pickupCoordinate"
let kDESTINATION_COORDINATES = "destinationCoordinates"
let kSTATE = "state"
let kDRIVER_UID = "driverUid"
