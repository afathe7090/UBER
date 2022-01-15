//
//  RideUBERXViewAction.swift
//  UBER
//
//  Created by Ahmed Fathy on 19/09/2021.
//

import UIKit
import MapKit

protocol RideUberXViewActionProtocol: AnyObject{
    func uploadTrip(_ view: RideUBERXViewAction)
    func deleteTrip()
}


enum RideUBERXViewConfiguration{
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    
    init(){
        self = .requestRide
    }
}


enum ButtonAction{
    case requestRide
    case cancel
    case getDirection
    case pickup
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide:
             return "CONFIRM UBERX"
        case .cancel:
            return "CANCEL RIDE"
        case .getDirection:
            return "GET PASSENGER"
        case .pickup:
            return "PICKUP OFF PASSENGER"
        case .dropOff:
            return "DROP OFF PASSENGER"
        }
    }
    
    init(){
        self = .requestRide
    }
}


class RideUBERXViewAction: UIView {
    
    //MARK: - Properties
    
    var destination: MKPlacemark? {
        didSet {
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
        }
    }
    
    var user: User?
    
    // delegate have a func  to action in Button Pressed
    weak var delegate: RideUberXViewActionProtocol?
    var config = RideUBERXViewConfiguration()
    var buttonAction = ButtonAction()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    	
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
	        return label
    }()
    
    
    private lazy var stackView: StackView = {
        let arrangedSubviews = [titleLabel , addressLabel]
        let stackView = StackView(arrangedSubviews: arrangedSubviews ,axis: .vertical, distribution: .fillEqually, spacing: 4)
        return stackView
    }()
    
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30

        view.addSubview(infoViewLabel)
        infoViewLabel.centerX(inView: view)
        infoViewLabel.centerY(inView: view)
        
        return view
    }()
    
    
    private lazy var infoViewLabel: UILabel = {
        
        let centerLabel = UILabel()
        centerLabel.text = "X"
        centerLabel.font = UIFont.systemFont(ofSize: 30)
        centerLabel.textColor = .white
        return centerLabel
    }()
    
    
    private lazy var uberInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "UberX"
        return label
    }()
    
    
    private lazy var seperatorView: UIView = {
        let sepertator = UIView()
        sepertator.backgroundColor = .lightGray
        return sepertator
    }()
    
    
    
    private lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(handelActionButtonPreseed), for: .touchUpInside)
        return btn
    }()
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureRideUBERXView()
        configureStackViewTitleLabel()
        configureInfoView()
        configureInfolabel()
        configureSeperatorView()
        configureActionButton()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    //MARK: - Selector
    
    @objc func handelActionButtonPreseed(){
        
        switch buttonAction {
            
        case .requestRide:
            delegate?.uploadTrip(self)
        case .cancel:
            delegate?.deleteTrip()
        case .getDirection:
            print("========= handel get directions")
        case .pickup:
            print("======== handel pickUp")
        case .dropOff:
            print("========= handel dropOff")
        }
    }
    
    
    //MARK: -  Function
    
    private func configureRideUBERXView(){
        
        backgroundColor = .white
        setShadowView(shadowColor: UIColor.black.cgColor, shadowOpacity: 0.6, shadowOffset: CGSize(width: 0, height: 0), cornerRadius: 5)
    }
    
    
    
    private func configureStackViewTitleLabel(){
        addSubview(stackView)
        stackView.centerX(inView: self)
        stackView.ancherConstrains(top: topAnchor ,paddingTop: 12)
    }
    
    
    
    private func configureInfoView(){
        
        addSubview(infoView)
        infoView.setDimenstions(60, 60)
        infoView.centerX(inView: self)
        infoView.ancherConstrains(top: stackView.bottomAnchor ,paddingTop: 12)
    }
    
    
    
    private func configureInfolabel(){
        addSubview(uberInfoLabel)
        uberInfoLabel.centerX(inView: self)
        uberInfoLabel.ancherConstrains(top: infoView.bottomAnchor, paddingTop: 5)
    }
    
    
    
    private func configureSeperatorView(){
        addSubview(seperatorView)
        seperatorView.centerX(inView: self)
        seperatorView.ancherConstrains(top: uberInfoLabel.bottomAnchor,left: leadingAnchor,right: trailingAnchor, paddingTop: 20, height: 0.75)
    }
    

    private func configureActionButton(){
        addSubview(actionButton)
        actionButton.centerX(inView: self)
        actionButton.ancherConstrains(top: seperatorView.bottomAnchor,left: leadingAnchor, right: trailingAnchor, paddingTop: 15 ,paddingLeft: 20 ,paddingRight: 20 ,height: 50)
    }
    
    
    //MARK: - Configure UI Ride Trip
    func configureUI(withConfig config: RideUBERXViewConfiguration){
        
        switch config {
            
        case .requestRide:
            
            buttonAction = .requestRide
            actionButton.setTitle(buttonAction.description, for: .normal)
            
        case .tripAccepted:
            
            guard let user = user else {return}
            if user.accountType == .passenger{
                titleLabel.text = "En Route To Passenger"
                buttonAction = .getDirection
                actionButton.setTitle(buttonAction.description, for: .normal)
            }else{
                titleLabel.text = "Driver En Route"
                buttonAction = .cancel
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            infoViewLabel.text = String(user.fullName.first ?? "X")
            uberInfoLabel.text = user.fullName
            
        case .pickupPassenger:
            
            titleLabel.text = "Arrived At Passenger Location"
            buttonAction = .pickup
            actionButton.setTitle(buttonAction.description, for: .normal)
            
        case .tripInProgress:
            
            guard let user = user else {return}
            if user.accountType == .driver {
                actionButton.setTitle("TRIP IN PROGRESS", for: .normal)
                actionButton.isEnabled = false
            }else{
                buttonAction = .getDirection
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            titleLabel.text = "En Route To Destination"
            
            
        case .driverArrived:
            guard let user = user else {return}
            if user.accountType == .driver {
                titleLabel.text = "Driver has Arrived"
                addressLabel.text = "Please Meet driver at pickup location"
            }
            
        case .endTrip:
            guard let user = user else {return}
            if user.accountType == .driver {
                actionButton.setTitle("ARRIVED AT DESTINATION", for: .normal)
            }else{
                buttonAction = .dropOff
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
        }
    }
}
