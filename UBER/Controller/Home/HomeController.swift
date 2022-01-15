//
//  HomeController.swift
//  HomeController
//
//  Created by Ahmed Fathy on 09/09/2021.
//

import UIKit
import Firebase
import MapKit

enum sideMenuBarType{
    case sideMenu
    case dismissActionView
    init() {
        self = .sideMenu
    }
}


class HomeController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Vaiables
    
    private let locationCellIdentifier = "LocationCell"
    private let annotationIdentifier = "DriverAnnotation"
    
    private let locationInputViewHeight: CGFloat = 200.0
    private let rideActionViewHeight: CGFloat = 300.0
    
    private var route: MKRoute?
    private var searchResult = [MKPlacemark]()
    
    private var actionMenuCongiure = sideMenuBarType()
    private let locationManager = LocationHandler.shared.locationManager
    
    private lazy var tableView =  UITableView()
    private let tap = UITapGestureRecognizer()
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> MARK: - USer
    //----------------------------------------------------------------------------------------------------------------
    private var user: User?{
        didSet{
            locationInputView.user = user
            
            if user?.accountType == .passenger{
                fetchDriversData()
                configureInputLocationView()
                observeCurrentTrip()
            }else{
                observeTrips()
            }
            
        }
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> MARK:  - Trip
    //----------------------------------------------------------------------------------------------------------------
    private var trip: Trip? {
        didSet{
            guard let user = user else { return}
            
            if user.accountType == .driver{
                let controller = PickUpController()
                controller.trip = trip
                controller.delegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }else{
                print("Acount is USer")
            }
            
        }
    }
    
    
    
    
    //MARK: - Properts UI
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Map View
    //----------------------------------------------------------------------------------------------------------------
    private lazy var mapView: MKMapView = {
        let map = MKMapView(frame: view.frame)
        map.showsUserLocation = true
        map.userTrackingMode = .followWithHeading
        return map
    }()
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> side menu bar
    //----------------------------------------------------------------------------------------------------------------
    private lazy var sideMenuBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(configureMenuBarButtonActionPressed), for: .touchUpInside)
        return button
    }()
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Ride Uber View
    //----------------------------------------------------------------------------------------------------------------
    
    private lazy var rideUberView: RideUBERXViewAction = {
        let rideView = RideUBERXViewAction()
        return rideView
    }()
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Input Location View
    //----------------------------------------------------------------------------------------------------------------
    private lazy var  inputLocationView: LocationInputActivationView = {
        let inputView = LocationInputActivationView()
        inputView.isUserInteractionEnabled = true
        inputView.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(handelTapGesture))
        return inputView
    }()
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Location Intput View
    //----------------------------------------------------------------------------------------------------------------
    private lazy var locationInputView: LocationInputView = {
        let locationInput = LocationInputView()
        locationInput.alpha = 0
        locationInput.delegate = self
        return locationInput
    }()
    
    
    
    //MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchUserData()
        
        configureTableView()
        
        //        signOut()
    }
    
    
    
    
    //MARK: - ========Selectors
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - tap gesture for Location Input View
    //----------------------------------------------------------------------------------------------------------------
    @objc func handelTapGesture(){
        configureLocationInputView()
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - side menu actions type
    //----------------------------------------------------------------------------------------------------------------
    @objc func configureMenuBarButtonActionPressed(){
        
        configureActionMenuBarButton()
    }
    
    
    //MARK: -  Functions UI
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - Configue UI
    //----------------------------------------------------------------------------------------------------------------
    private func configureUI(){
        
        configureMapView()
        configureRideUberView()
        configureMenuButton()
        
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - Configure Map View
    //----------------------------------------------------------------------------------------------------------------
    
    private func configureMapView(){
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.userTrackingMode = .follow
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - configureInput Location view
    //----------------------------------------------------------------------------------------------------------------
    private func configureInputLocationView(){
        
        view.addSubview(inputLocationView)
        UIView().setAlphaAnimation(inputLocationView)
        inputLocationView.centerX(inView: view)
        inputLocationView.setDimenstions(50, view.frame.width - 64 )
        inputLocationView.ancherConstrains(top: sideMenuBarButton.bottomAnchor, paddingTop: 30)
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> MARK: -  Menu Button Configure
    //----------------------------------------------------------------------------------------------------------------
    private func configureMenuButton(){
        view.addSubview(sideMenuBarButton)
        sideMenuBarButton.ancherConstrains(top: view.safeAreaLayoutGuide.topAnchor , left: view.leadingAnchor ,paddingTop: 15 ,paddingLeft: 15 , width: 30, height: 30)
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> MARK: -  Configure Ride View
    //----------------------------------------------------------------------------------------------------------------
    
    private func configureRideUberView(){
        view.addSubview(rideUberView)
        rideUberView.delegate = self
        rideUberView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: rideActionViewHeight)
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Loction Input View
    //----------------------------------------------------------------------------------------------------------------
    private func configureLocationInputView(){
        
        view.addSubview(locationInputView)
        locationInputView.ancherConstrains(top: view.topAnchor,left: view.leadingAnchor , right: view.trailingAnchor,height: locationInputViewHeight)
        
        inputLocationView.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
        
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Configure TableView
    //----------------------------------------------------------------------------------------------------------------
    private func configureTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(LocationCell.self, forCellReuseIdentifier: locationCellIdentifier)
        tableView.rowHeight = 60
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        view.addSubview(tableView)
        
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Dismiss Input View
    //----------------------------------------------------------------------------------------------------------------
    private func dismissInputView(completion: ((Bool)-> Void)? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
            
        }, completion: completion)
    }
    
    
    
    //MARK: - maps Placemark + polyline
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Show Ride Requset
    //----------------------------------------------------------------------------------------------------------------
    
    private func showRideRequest(shouldShow: Bool, distination: MKPlacemark? = nil ,
                                 config: RideUBERXViewConfiguration? = nil,user: User? = nil){
        
        let yOrigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight:self.view.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.rideUberView.frame = CGRect(x: 0, y: yOrigin, width: self.view.frame.width, height: self.rideActionViewHeight)
        }
        
        if shouldShow {
            
            guard let config = config else {
                return
            }

            if let distination = distination {
                rideUberView.destination = distination
            }
            
            if let user = user{
                rideUberView.user = user
            }
            
            rideUberView.configureUI(withConfig: config)
            
        }
    }
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  remove polyline
    //----------------------------------------------------------------------------------------------------------------
    
    private func removePolylineAndAnotation(){
        
        mapView.annotations.forEach { annotation in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
        if mapView.overlays.count > 0{
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
    
    
    
    
    
    //MARK: - API Services
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> MARK: - fetch User Data
    //----------------------------------------------------------------------------------------------------------------
    private func fetchUserData(){
        
        guard let currentId = Auth.auth().currentUser?.uid else{return}
        FUSerListener.shared.fetchUserData(uid: currentId) { user in
            self.user = user
        }
    }
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Fetch Driver Data
    //----------------------------------------------------------------------------------------------------------------
    private func fetchDriversData(){
        
        guard let location = self.locationManager?.location else{return}
        FDriverListener.shared.fetchDrivers(location: location) { (driver) in
            
            guard let coordinate = driver.location?.coordinate else{return}
            
            let annotation = DriverAnnotation(uid: driver.uid!, coordinate: coordinate)
            var driverIsVisable: Bool {
                return self.mapView.annotations.contains { annotation in
                    guard let driverAnno = annotation as? DriverAnnotation else{return false}
                    if driverAnno.uid == driver.uid{
                        driverAnno.updateAnnotationPostion(withCoordinate: coordinate)
                        return true
                    }
                    return false
                }
            }
            
            if !driverIsVisable{
                self.mapView.addAnnotation(annotation)
            }
            
        }
        
    }
    
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> MARK: - observe Trips
    //----------------------------------------------------------------------------------------------------------------
    private func observeTrips(){
        FTripListener.shared.observeTrips { trip in
            self.trip = trip
            
            if trip.state == .accepted{
                
                print("==================== Accepted Trip ")
            }
        }
    }
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> MARK: -  Observe Current Trip
    //----------------------------------------------------------------------------------------------------------------
    private func observeCurrentTrip(){
        FTripListener.shared.observeCurrentTrip(completion: {trip in
            self.trip = trip
            
            if trip.state == .accepted{
                
                self.shouldPresentLoaginView(false)
                guard let driverUid = trip.driverUid else{return}
                
                FUSerListener.shared.fetchUserData(uid: driverUid) { driver in
                    self.showRideRequest(shouldShow: true, config: .tripAccepted, user: driver)
                }
            }
        })
    }
    
    
    
    
    
    
    //MARK: - Side Menu Button Types Handeler
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Configure Menu Button
    //----------------------------------------------------------------------------------------------------------------
    private func configureMenuBarModeAction(_ mode: sideMenuBarType){
        switch mode{
        case .sideMenu:
            self.sideMenuBarButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp"), for: .normal)
            self.actionMenuCongiure = .sideMenu
        case .dismissActionView:
            self.sideMenuBarButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1"), for: .normal)
            self.actionMenuCongiure = .dismissActionView
        }
        
    }
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Function for selector Menu Bar
    //----------------------------------------------------------------------------------------------------------------
    private func configureActionMenuBarButton(){
        
        switch actionMenuCongiure {
        case .sideMenu:
            print(" ===========SideMenu")
        case .dismissActionView:
            
            removePolylineAndAnotation()
            mapView.showAnnotations(mapView.annotations, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.inputLocationView.alpha = 1
                self.configureMenuBarModeAction(.sideMenu)
                self.showRideRequest(shouldShow: false)
            }
            
            
        }
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - sign Out
    //----------------------------------------------------------------------------------------------------------------
    private func signOut(){
        
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.goToLogin()
            }
        }catch{
            print("Can't Sign Out")
        }
    }
    
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Go to Login page
    //----------------------------------------------------------------------------------------------------------------
    private func goToLogin(){
        
        let nav = UINavigationController(rootViewController: LoginController())
        nav.modalPresentationStyle = .fullScreen
        saveCurrentID("")
        present(nav, animated: true, completion: nil)
    }
    
    
    
}

//MARK: - LocationInputViewDelegate
extension HomeController: LocationInputViewDelegate{
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  search result from text Field
    //----------------------------------------------------------------------------------------------------------------
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (results) in
            self.searchResult = results
            self.tableView.reloadData()
        }
    }
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  dismiss Location Input View
    //----------------------------------------------------------------------------------------------------------------
    func dismissLocationInputView() {
        
        dismissInputView { _ in
            UIView.animate(withDuration: 0.5) {
                self.inputLocationView.alpha = 1
            }
        }
    }
}


//MARK: - Private extention HomeController

private extension HomeController{
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: -  Search by Loaction name
    //----------------------------------------------------------------------------------------------------------------
    func searchBy(naturalLanguageQuery: String , completion: @escaping([MKPlacemark])-> Void){
        
        var results = [MKPlacemark]()
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else{return}
            
            response.mapItems.forEach({ (Item) in
                results.append(Item.placemark)
            })
            completion(results)
        }
    }
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - genetratePolyLine
    //----------------------------------------------------------------------------------------------------------------
    func genetratePolyLine(forDisnation distnation: MKMapItem){
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = distnation
        request.transportType = .automobile
        
        let directRequest = MKDirections(request: request)
        directRequest.calculate { responce, error in
            guard let responce = responce else{return }
            self.route = responce.routes[0]
            guard let polyline  = self.route?.polyline else{return}
            self.mapView.addOverlay(polyline)
        }
    }
    
    func centerMapOnUserLoaction(){
        guard let coordinate = locationManager?.location?.coordinate else{return}
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
}




//MARK: - Map View Kit

extension HomeController: MKMapViewDelegate {
        
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let user = self.user else{return}
        guard  user.accountType == .driver else{return}
        guard let location = userLocation.location else{return}
        
        FDriverListener.shared.updateDriverLocation(location: location)
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - Driver Notation Map View
    //----------------------------------------------------------------------------------------------------------------
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let route = self.route {
            let polyline = route.polyline
            let lineRender = MKPolylineRenderer(overlay: polyline)
            lineRender.strokeColor = .black
            lineRender.fillColor = .black
            lineRender.lineWidth = 3
            return lineRender
        }
        return MKOverlayRenderer()
    }
}




//MARK: - UITableViewDataSource/Delegate

extension HomeController: UITableViewDataSource ,UITableViewDelegate{
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - number of Section
    //----------------------------------------------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - number of row in section
    //----------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2:searchResult.count
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - cell for row at
    //----------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier, for: indexPath) as! LocationCell
        
        if indexPath.section == 1{
            cell.placemark = searchResult[indexPath.row]
        }
        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - Height fot Footer Section
    //----------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - View of Header section
    //----------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 0.8)
        return view
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - did Select Row at
    //----------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = self.searchResult[indexPath.row]
        
        configureMenuBarModeAction(.dismissActionView)
        
        let distnation = MKMapItem(placemark: selectedPlacemark)
        genetratePolyLine(forDisnation: distnation)
        
        dismissInputView { _ in
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            let annotations = self.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self)})
            self.mapView.zoomToFit(annotations: annotations)
            self.showRideRequest(shouldShow: true, distination: selectedPlacemark ,config: .requestRide)
        }
    }
    
}



//MARK: - RideUberXViewActionProtocol

extension HomeController: RideUberXViewActionProtocol{
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - Upload trip
    //----------------------------------------------------------------------------------------------------------------
    func uploadTrip(_ view: RideUBERXViewAction) {
        guard let pickupCoordinates = self.locationManager?.location?.coordinate else{return}
        guard let destinations = view.destination?.coordinate else{return}
        
        shouldPresentLoaginView(true, messsage: "Finding you a ride....")
        FTripListener.shared.uploadTrip(pickupCoordinates, destinations) { (error , referance) in
            
            if let error = error {
                print(" ===================== Fails Rther Error \(error)")
                return
            }

            UIView.animate(withDuration: 0.3) {
                self.rideUberView.frame.origin.y = self.view.frame.height
            }
        }
    }
    
    //MARK: - cancel Trip
    func deleteTrip() {
        
        FTripListener.shared.deleteTrip { error, ref in
            if let error = error {
                print("Error Deleting Trip \(error.localizedDescription)")
                return
            }
            self.showRideRequest(shouldShow: false)
            self.removePolylineAndAnotation()
            self.sideMenuBarButton.setImage(UIImage(named: "baseline_menu_black_36dp"), for: .normal)
            self.actionMenuCongiure = .sideMenu
            self.centerMapOnUserLoaction()
            
        }
    }
}

//MARK: - PickUpControllerDelegate
extension HomeController: PickUpControllerDelegate{
    
    //----------------------------------------------------------------------------------------------------------------
    //=======>MARK: - Did Accepted Trip
    //----------------------------------------------------------------------------------------------------------------
    func didAcceptedTrip(_ trip: Trip) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = trip.pickupCoordinate
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        let placemark = MKPlacemark(coordinate: trip.pickupCoordinate)
        let mapItem = MKMapItem(placemark: placemark)
        genetratePolyLine(forDisnation: mapItem)

        mapView.zoomToFit(annotations: mapView.annotations)
        
        FUSerListener.shared.fetchUserData(uid: trip.passengerUid) { passenger in
            self.showRideRequest(shouldShow: true, config: .tripAccepted, user: passenger)
        }
        
        
        FTripListener.shared.observeTripCancelled(trip: trip) {
            self.removePolylineAndAnotation()
            self.showRideRequest(shouldShow: false)
            self.mapView.zoomToFit(annotations: self.mapView.annotations)
            self.presentAlertController(withTitle: "Oops!", message: "The Passenger decided to cancel this ride. Press Ok to continue.")
        }
        self.dismiss(animated: true,completion: nil)
    }
    
}
