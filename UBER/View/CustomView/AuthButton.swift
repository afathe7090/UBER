//
//  AuthButton.swift
//  AuthButton
//
//  Created by Ahmed Fathy on 07/09/2021.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        backgroundColor = .mainBlueTint
        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
