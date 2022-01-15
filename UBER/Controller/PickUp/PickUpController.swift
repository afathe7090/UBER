//
//  PickUpController.swift
//  UBER
//
//  Created by Ahmed Fathy on 27/09/2021.
//

import UIKit
import MapKit


protocol PickUpControllerDelegate: AnyObject{
    func didAcceptedTrip(_ trip: Trip)
}


class PickUpController: UIViewController {
    
    //MARK: - Variable
    
    var trip: Trip?
    weak var delegate: PickUpControllerDelegate?
    
    //MARK: - Properties
    
    // =====> Map View
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()

    
    // =====> cancel Button
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ic_highlight_off_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(handelCancelButton), for: .touchUpInside)
        return btn
    }()
    
    
    // =====> pick Up Label
    private lazy var pickUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Would you like to pickup this Passenger?"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    
    // =====> accenpt Trip Button
    private lazy var acceptTripButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("ACCEPT TRIP", for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(handelAcceptTripButton), for: .touchUpInside)
        return btn
    }()
    
    
    
    //MARK: - lifeCycle
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Status Bar Hidden
    //----------------------------------------------------------------------------------------------------------------
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    //MARK: - Selectors
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> selector cancel Button
    //----------------------------------------------------------------------------------------------------------------
    @objc func handelCancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Selector accept trip Button
    //----------------------------------------------------------------------------------------------------------------
    @objc func handelAcceptTripButton(){
        guard let trip = trip else {  return}

        FTripListener.shared.acceptTrip(trip: trip) { error, referance in
            self.delegate?.didAcceptedTrip(trip)
        }
    }
    
    //MARK: - Api
    
    
    //MARK: -  Helper Function
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Configure UI
    //----------------------------------------------------------------------------------------------------------------
    private func configureUI(){
        
        configureViewController()
        configureCancelButton()
        configureMapView()
        configurePickUpLabel()
        configureAcceptTripButton()
        handeltripInMapView()
    }
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Confiure ViewController
    //----------------------------------------------------------------------------------------------------------------
    private func configureViewController(){
        view.backgroundColor = .backgoundColor
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> cofnfiure Cancel Button
    //----------------------------------------------------------------------------------------------------------------
    private func configureCancelButton(){
        view.addSubview(cancelButton)
        cancelButton.ancherConstrains(top: view.safeAreaLayoutGuide.topAnchor , left: view.leadingAnchor,paddingTop: 16 ,paddingLeft: 16)
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Configrue Map View
    //----------------------------------------------------------------------------------------------------------------
    private func configureMapView(){
        
        view.addSubview(mapView)
        mapView.setDimenstions(270, 270)
        mapView.layer.cornerRadius = 270 / 2
        mapView.centerX(inView: view)
        mapView.centerY(inView: view, constant: -200)
                
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Configure PickUpLabel
    //----------------------------------------------------------------------------------------------------------------
    private func configurePickUpLabel(){
        view.addSubview(pickUpLabel)
        pickUpLabel.centerX(inView: view)
        pickUpLabel.ancherConstrains(top: mapView.bottomAnchor , paddingTop: 20)
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Configure Accept Trip Button
    //----------------------------------------------------------------------------------------------------------------
    private func configureAcceptTripButton(){
        view.addSubview(acceptTripButton)
        acceptTripButton.centerX(inView: view)
        acceptTripButton.ancherConstrains(top: pickUpLabel.bottomAnchor,
                                          left: view.leadingAnchor,
                                          right: view.trailingAnchor,
                                          paddingTop: 20,
                                          paddingLeft: 20 ,
                                          paddingRight: 20, height: 50)
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Handel Trip In Map View
    //----------------------------------------------------------------------------------------------------------------
    private func handeltripInMapView(){
        
        guard let trip = trip else{return}
        let region = MKCoordinateRegion(center: trip.pickupCoordinate, latitudinalMeters: 1000 , longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)

        let annotation = MKPointAnnotation()
        annotation.coordinate = trip.pickupCoordinate
        mapView.addAnnotation(annotation)
    }
}
