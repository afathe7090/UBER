//
//  SegmentedControl.swift
//  SegmentedControl
//
//  Created by Ahmed Fathy on 07/09/2021.
//

import UIKit

class SegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
        
        insertSegment(withTitle: "Rider", at: 0, animated: true)
        insertSegment(withTitle: "Driver", at: 1, animated: true)
        backgroundColor = .clear
        layer.borderColor =  UIColor.lightGray.cgColor
        layer.borderWidth = 2
        tintColor = .blue
        
        heightAnchor.constraint(equalToConstant: 35).isActive = true
        setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18) as Any,NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18) as Any,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)], for: .selected)
        selectedSegmentIndex = 0
        
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
}
