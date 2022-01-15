//
//  LocationInputView.swift
//  LocationInputView
//
//  Created by Ahmed Fathy on 09/09/2021.
//

import UIKit

protocol LocationInputViewDelegate: AnyObject{
    func dismissLocationInputView()
    func executeSearch(query: String)
}


class LocationInputView: UIView {
    
    //MARK: - Propertes
    
    
    weak var delegate: LocationInputViewDelegate?
    
    var user: User? {
        didSet{titleLabel.text = user?.fullName}
    }
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "baseline_arrow_back_black_36dp"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(handelBackButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mohamed"
        label.numberOfLines = 1
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var linkingView: UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var endingLocationIndecatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Current Location"
        textField.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 299/255, alpha: 0.95)
        textField.isEnabled = true
        textField.clearButtonMode = .always
        let paddingView = UIView()
        paddingView.setDimenstions(30, 8)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var distinationLocationTextField: UITextField = {
        let tf = UITextField()
        
        tf.delegate = self
        tf.placeholder = "Enter a destination....."
        tf.backgroundColor = .lightGray
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.clearButtonMode = .always
        let paddingView = UIView()
        paddingView.setDimenstions(30, 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSelfView()
        
        configureBackButton()
        
        configureTitleLabel()
        
        configureStartLocationTextField()
        
        configuredistinationLocationTextField()
        
        configureStartLocationIndicatorView()
        
        configureDistinationVIndicatorView()
        
        configureLinkedView()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    //MARK: -  selectors
    
    @objc func handelBackButtonPressed(){
        delegate?.dismissLocationInputView()
    }
    
    
    
    
    //MARK: - Functions
    
    private func configureSelfView(){
        backgroundColor = .white
        self.setShadowView(shadowColor: UIColor.black.cgColor, shadowOpacity: 0.45, shadowOffset: CGSize(width: 0.5, height: 0.5), cornerRadius: 5)
    }
    
    private func configureBackButton(){
        addSubview(backButton)
        backButton.ancherConstrains(top: topAnchor ,left: leadingAnchor, paddingTop: 44,paddingLeft: 12 , width: 24, height: 25)
    }
    
    private func configureTitleLabel(){
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
    }
    
    private func configureStartLocationTextField(){
        
        addSubview(startLocationTextField)
        startLocationTextField.ancherConstrains(top: titleLabel.bottomAnchor , left: leadingAnchor,right: trailingAnchor , paddingTop: 20, paddingLeft: 40 , paddingRight: 40 ,height: 40)
    }
    
    private func configuredistinationLocationTextField(){
        addSubview(distinationLocationTextField)
        distinationLocationTextField.ancherConstrains(top: startLocationTextField.bottomAnchor , left: leadingAnchor,right: trailingAnchor , paddingTop: 12, paddingLeft: 40 , paddingRight: 40 ,height: 40)
    }
    
    private func configureStartLocationIndicatorView(){
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(inView: startLocationTextField)
        startLocationIndicatorView.ancherConstrains(left: leadingAnchor , paddingLeft: 20)
        startLocationIndicatorView.setDimenstions(6, 6)
        startLocationIndicatorView.layer.cornerRadius = 3
    }
    
    private func configureDistinationVIndicatorView(){
        
        addSubview(endingLocationIndecatorView)
        endingLocationIndecatorView.centerY(inView: distinationLocationTextField)
        endingLocationIndecatorView.ancherConstrains(left: leadingAnchor , paddingLeft: 20)
        endingLocationIndecatorView.setDimenstions(6, 6)
        endingLocationIndecatorView.layer.cornerRadius = 3
    }
    
    private func configureLinkedView(){
        
        addSubview(linkingView)
        linkingView.centerX(inView: startLocationIndicatorView)
        linkingView.ancherConstrains(top: startLocationIndicatorView.bottomAnchor,bottom: endingLocationIndecatorView.topAnchor , paddingTop: 2,paddingBottom: 2,width: 2)
    }
    
}


extension LocationInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else{return false}
        
        delegate?.executeSearch(query: query)
        textField.endEditing(true)
        return true
    }
}
