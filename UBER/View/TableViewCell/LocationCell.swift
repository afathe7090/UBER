//
//  LocationCell.swift
//  LocationCell
//
//  Created by Ahmed Fathy on 10/09/2021.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    
    
    var placemark: MKPlacemark?{
        didSet{
            titleLabel.text = placemark?.name
            addressLabel.text = placemark?.address
        }
    }


    //MARK: - Properites
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        let arranged = [titleLabel , addressLabel]
        let stackView = StackView(arrangedSubviews: arranged, axis: .vertical, distribution: .fillEqually, spacing: 4)
        
        contentView.addSubview(stackView)
        stackView.centerY(inView: contentView)
        stackView.ancherConstrains(left: leadingAnchor,paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
}
