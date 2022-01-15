//
//  DriverAnotation.swift
//  UBER
//
//  Created by Ahmed Fathy on 15/09/2021.
//

import MapKit

class DriverAnnotation: NSObject , MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D

    var uid: String
    
    
    init(uid: String , coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        self.uid = uid
        
    }
    
    
    func updateAnnotationPostion(withCoordinate coordinate: CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}
