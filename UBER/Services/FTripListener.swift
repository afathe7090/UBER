//
//  FTripListener.swift
//  UBER
//
//  Created by Ahmed Fathy on 01/10/2021.
//

import Firebase
import CoreLocation
import GeoFire

class FTripListener{
    
    static let shared = FTripListener()
    
    //MARK: - Upload trip
    func uploadTrip(_ pickupCoordinate: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, commpletion:@escaping(Error? ,DatabaseReference)-> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let pickupArray = [pickupCoordinate.latitude,pickupCoordinate.longitude]
        let destinationArray = [destinationCoordinates.latitude , destinationCoordinates.longitude]
        let values = [kPICKUP_COORDINATE: pickupArray ,
                kDESTINATION_COORDINATES: destinationArray,
                                  kSTATE: TripState.requested.rawValue] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: commpletion)
    }
    
    
    
    //MARK: - Listen To Observe Trip
    func observeTrips(completion: @escaping(Trip)->Void){
        REF_TRIPS.observe(.childAdded) { (snapsot) in
            guard let dectionary = snapsot.value as? [String:Any] else{return}
            let uid = snapsot.key
            let trip = Trip(passengerUid: uid, dictionary: dectionary)
            completion(trip)
        }
    }
    
    
    
    //MARK: - Accepted trip
    func acceptTrip(trip: Trip, commplation:@escaping(Error? ,DatabaseReference)->Void){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        let values = [kDRIVER_UID: uid,
                           kSTATE: TripState.accepted.rawValue] as [String: Any]
        
        REF_TRIPS.child(trip.passengerUid!).updateChildValues(values, withCompletionBlock: commplation)
        
    }
    
    
    
    //MARK: - observe Current Trip
    func observeCurrentTrip(completion:@escaping(Trip)->Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        REF_TRIPS.child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else{return}
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            
            completion(trip)
        }
    }
    
    
    
    //MARK: - delete Trip
    func deleteTrip(completion: @escaping(Error? , DatabaseReference?)->Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        REF_TRIPS.child(uid).removeValue(completionBlock: completion)
    }
    
    
    func observeTripCancelled(trip: Trip, completion: @escaping()-> Void){
        REF_TRIPS.child(trip.passengerUid).observeSingleEvent(of: .childRemoved) { _ in
            completion()
        }
    }
    
    
}
