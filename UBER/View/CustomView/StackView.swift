//
//  StackView.swift
//  StackView
//
//  Created by Ahmed Fathy on 07/09/2021.
//

import UIKit

class StackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    init(arrangedSubviews: [UIView]  ,axis: NSLayoutConstraint.Axis , distribution: UIStackView.Distribution,spacing: CGFloat ){
        super.init(frame: .zero)
        for item in arrangedSubviews{
            self.addArrangedSubview(item)
        }
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
