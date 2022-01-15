//
//  LocationInputActivationView.swift
//  LocationInputActivationView
//
//  Created by Ahmed Fathy on 09/09/2021.
//

import UIKit


class LocationInputActivationView: UIView {
    
    //MARK: - Properties
    
    private lazy var indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    
    
    private lazy var placeholderLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Where to ? "
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        alpha = 0
        
        self.setShadowView(shadowColor: UIColor.black.cgColor, shadowOpacity: 0.45, shadowOffset: CGSize(width: 0.5, height: 0.5), cornerRadius: 5)
        
        
        addSubview(indicatorView)
        indicatorView.centerY(inView: self)
        indicatorView.ancherConstrains(left: leadingAnchor , paddingLeft: 16)
        indicatorView.setDimenstions(6, 6)
        
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self)
        placeholderLabel.ancherConstrains(left: indicatorView.trailingAnchor , paddingLeft: 20)
        
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
}
