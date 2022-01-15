//
//  FDriverListener.swift
//  UBER
//
//  Created by Ahmed Fathy on 01/10/2021.
//

import Firebase
import CoreLocation
import GeoFire

class FDriverListener{
    
    static let shared = FDriverListener()
    
    //MARK: - Driver Data
    func fetchDrivers(location: CLLocation, completion: @escaping(User)-> Void){
        let geoFire = GeoFire(firebaseRef: REF_DRIVERS_LOCATION)
        REF_DRIVERS_LOCATION.observe(.value) { (snapshot) in
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered,with: { (uid , location) in
                FUSerListener.shared.fetchUserData(uid: uid) { user in
                    var dirvers = user
                    dirvers.location = location
                    completion(dirvers)
                }
            })
        }
    }
    
    
    //MARK: - Location Driver
    func saveDriverLocationFirebase(_ driverIndex: Int ,uid: String , location: CLLocation? , value: [String:Any]){
        
        if driverIndex == 1{
            let geoFire = GeoFire(firebaseRef: REF_DRIVERS_LOCATION)
            guard let location = location else{return}
            
            geoFire.setLocation(location, forKey: uid) { error in
                FUSerListener.shared.saveUserInDataBase(uid: uid, value: value) { error in
                    if let error = error {
                        print("Error To Save Driver Location\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    //MARK: - Update Driver Location
    func updateDriverLocation(location: CLLocation){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let geoFire = GeoFire(firebaseRef: REF_DRIVERS_LOCATION)
        geoFire.setLocation(location, forKey: uid)
    }
    
}
