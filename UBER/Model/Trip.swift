//
//  Trip.swift
//  UBER
//
//  Created by Ahmed Fathy on 22/09/2021.
//

import CoreLocation



enum TripState: Int{
    case requested
    case accepted
    case driverArrived
    case inProgress
    case completed
}

class Trip{
    
    var pickupCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    let passengerUid: String!
    var driverUid: String?
    
    var state: TripState!

    init(passengerUid: String ,dictionary: [String:Any]){
        
        
        self.passengerUid = passengerUid
        
        if let pickupCoordinate = dictionary[kPICKUP_COORDINATE] as? NSArray {
            guard let lat  = pickupCoordinate[0] as? CLLocationDegrees else{return}
            guard let long = pickupCoordinate[1] as? CLLocationDegrees else{return}
            
            self.pickupCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let destinationCoordinate = dictionary[kDESTINATION_COORDINATES] as? NSArray {
            guard let lat  = destinationCoordinate[0] as? CLLocationDegrees else{return}
            guard let long = destinationCoordinate[1] as? CLLocationDegrees else{return}
            
            self.destinationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        
        self.driverUid = dictionary[kDRIVER_UID] as? String ?? ""
        
        if let state = dictionary[kSTATE] as?  Int {
            self.state = TripState(rawValue: state)
        }
    }
    
    
}
