//
//  Extentions.swift
//  Extentions
//
//  Created by Ahmed Fathy on 06/09/2021.
//

import UIKit
import MapKit


//MARK: -  View
extension UIView{
    
    func ancherConstrains(top: NSLayoutYAxisAnchor? = nil,
                          left: NSLayoutXAxisAnchor? = nil,
                          bottom: NSLayoutYAxisAnchor? = nil,
                          right: NSLayoutXAxisAnchor? = nil,
                          paddingTop: CGFloat = 0,
                          paddingLeft: CGFloat = 0,
                          paddingBottom: CGFloat = 0,
                          paddingRight: CGFloat = 0,
                          width: CGFloat? = nil ,
                          height: CGFloat? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
    func centerX(inView view: UIView){
        translatesAutoresizingMaskIntoConstraints  = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    
    func centerY(inView view: UIView, constant: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
    
    
    //MARK: - hanedel image text Field

    func handelTextFieldImage(_ image: UIImage)-> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        imageView.tintColor = UIColor(white: 1, alpha: 0.87)
        
        view.addSubview(imageView)
        return view
    }
    
    
    
    //MARK: -  handel Seperator TestField
    func handelSeperatorView(_ slaveView: UIView)-> UIView{
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        DispatchQueue.main.async {
            view.ancherConstrains(top: slaveView.bottomAnchor,left: slaveView.leadingAnchor ,right: slaveView.trailingAnchor ,height: 1.2)
        }
        
        return view
    }

    
    //MARK: - setDimintion
    func setDimenstions(_ height: CGFloat , _ width: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    
    //MARK: - setAlphaAnimation
    func setAlphaAnimation(_ animationView: UIView){
        animationView.alpha = 0
        UIView.animate(withDuration: 2) {
            animationView.alpha = 1
        }
    }
    
    //MARK: - setShadowView
    func setShadowView(shadowColor: CGColor, shadowOpacity: Float,shadowOffset: CGSize, cornerRadius: CGFloat){
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.cornerRadius = cornerRadius
    }
}


//MARK: -  TextField
extension UITextField {
    
    func textField(withPlaceHolder placehloder: String, imageLeft: UIImage , isSecureTextEntry: Bool)-> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.attributedPlaceholder = NSAttributedString(string: placehloder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.isSecureTextEntry = isSecureTextEntry
        textField.leftView = UIView().handelTextFieldImage(imageLeft)
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        return textField
    }
    
    
}


//MARK: -  Color

extension UIColor {
    
    static func rgbColor(_ red: CGFloat ,_ grean: CGFloat ,_ blue: CGFloat)-> UIColor {
        return UIColor(red: red/255, green: grean/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgoundColor = UIColor.rgbColor(25, 25, 25)
    static let mainBlueTint = UIColor.rgbColor(17, 154, 237)
    
}



extension MKPlacemark{
    
    var address: String?{
        get {
            guard let subThoroughfare = subThoroughfare else{return nil}
            guard let thoroughfare = thoroughfare else{return nil}
            guard let locality = locality else{return nil}
            guard let adminArea = administrativeArea else{return nil}
            
            return "\(subThoroughfare) \(thoroughfare) \(locality) \(adminArea)"
        }
    }
}



extension MKMapView{
    
    func zoomToFit(annotations: [MKAnnotation]){
        var zoomRect = MKMapRect.null
        
        annotations.forEach { annotation in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        setVisibleMapRect(zoomRect,edgePadding: insets, animated: true)
    }
}





//MARK: - ViewController

extension UIViewController{
    
    func presentAlertController(withTitle title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert
                     ,animated: true, completion: nil)
    }
    
    
    
    
    func shouldPresentLoaginView(_ present: Bool, messsage: String? = nil){
        
        if present{
            
            let loadinView = UIView()
            loadinView.frame = self.view.frame
            loadinView.backgroundColor = .black
            loadinView.alpha = 0
            loadinView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            indicator.style = .large
            indicator.color = .white
            indicator.setDimenstions(60, 60)
            
            let label = UILabel()
            label.text = messsage
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .white
            label.alpha = 0.7
            
            view.addSubview(loadinView)
            loadinView.addSubview(indicator)
            loadinView.addSubview(label)
            
            indicator.centerX(inView: loadinView)
            indicator.centerY(inView: loadinView)
            label.centerX(inView: view)
            label.ancherConstrains(top: indicator.bottomAnchor,paddingTop: 20)
           
            indicator.startAnimating()

            UIView.animate(withDuration: 0.3) {
                loadinView.alpha = 0.7
            }
            
        }else{
            view.subviews.forEach { subView in
                if subView.tag == 1 {
                    UIView.animate(withDuration: 0.3) {
                        subView.alpha = 0
                    } completion: { _ in
                        subView.removeFromSuperview()
                    }

                }
            }
        }
        
    }
    
    
}


