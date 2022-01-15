//
//  LocationHandler.swift
//  UBER
//
//  Created by Ahmed Fathy on 15/09/2021.
//

import CoreLocation

class LocationHandler: NSObject , CLLocationManagerDelegate{
    
    static let shared = LocationHandler()
    
    var location: CLLocation?
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        enableLocationsServices()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    
    func enableLocationsServices(){

            switch locationManager?.authorizationStatus {
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            case .restricted,.denied:
                break
                
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
            case .authorizedWhenInUse:
                locationManager.requestAlwaysAuthorization()
                
            case .none:
                print("None Action")
                
            @unknown default:
                break
            }
    }
    
}
