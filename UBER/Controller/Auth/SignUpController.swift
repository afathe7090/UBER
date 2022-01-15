//
//  SignUpController.swift
//  SignUpController
//
//  Created by Ahmed Fathy on 06/09/2021.
//

import UIKit
import Firebase
import GeoFire

class SignUpController: UIViewController {
    
    
    //MARK: - Variables
    
    private let location = LocationHandler.shared.locationManager.location
    
    
    //MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "UBER"
        lb.textColor = UIColor(white: 1, alpha: 0.8)
        lb.font = UIFont(name: "Avenir-Light", size: 36)
        return lb
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var emailTextField: UITextField = {
        return UITextField().textField(withPlaceHolder: "Email", imageLeft: UIImage(named: "ic_mail_outline_white_2x")!, isSecureTextEntry: false)
    }()
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var emailSeperatorView: UIView = {
        return UIView().handelSeperatorView(emailTextField)
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    
    private lazy var fullNameTextField: UITextField = {
        return UITextField().textField(withPlaceHolder: "Full Name", imageLeft: UIImage(named: "ic_person_outline_white_2x")!, isSecureTextEntry: false)
    }()
    
        
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var fullNameSeperatorView: UIView = {
        return UIView().handelSeperatorView(fullNameTextField)
    }()
    
    
        
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var passwordTextField: UITextField = {
        return UITextField().textField(withPlaceHolder: "password", imageLeft: UIImage(named: "ic_lock_outline_white_2x")!, isSecureTextEntry: true)
    }()
    
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var passwordSeperatorView: UIView = {
        return UIView().handelSeperatorView(passwordTextField)
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    
    private lazy var accountTypeSgmentedControl: UISegmentedControl = {
        let segment = SegmentedControl()
        return segment
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var stackView: UIStackView = {
        let  arrangedSubviews =  [emailTextField,
                                  fullNameTextField,
                                  passwordTextField ,
                                  accountTypeSgmentedControl,
                                  signUpButton]
        
        let stackView = StackView(arrangedSubviews: arrangedSubviews, axis: .vertical, distribution: .fillProportionally, spacing: 20)
        return stackView
    }()
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var signUpButton: UIButton = {
        let btn = AuthButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitle("Sign In", for: .normal)
        btn.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
        
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var haveAnAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 16) ,.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.font: UIFont.systemFont(ofSize: 16) , .foregroundColor: UIColor.mainBlueTint]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(signInBtnPressedAction), for: .touchUpInside)
        return button
    }()
        
    
    
    //MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        handelTitlelabelConstrains()
        stackViewConstrains()
        handelHaveAccountButton()
        
    }
    
    
    //MARK: - Actions
    
    
    @objc func signInBtnPressedAction(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func signUpButtonPressed(){
        
        registerUsersFirebase()
    }
    
    
    //MARK: - Functions
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private func setViewController(){
        
        view.addSubview(emailSeperatorView)
        view.addSubview(passwordSeperatorView)
        view.addSubview(fullNameSeperatorView)
        view.backgroundColor = .backgoundColor
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private func handelTitlelabelConstrains(){
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.ancherConstrains(top: view.safeAreaLayoutGuide.topAnchor)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private func stackViewConstrains(){
        view.addSubview(stackView)
        stackView.ancherConstrains(top: titleLabel.bottomAnchor , left: view.leadingAnchor , right: view.trailingAnchor ,paddingTop: 40 ,paddingLeft: 20 ,paddingRight: 20)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private func handelHaveAccountButton(){
        view.addSubview(haveAnAccountButton)
        haveAnAccountButton.centerX(inView: view)
        haveAnAccountButton.ancherConstrains(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    
    //MARK: - Register
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private func registerUsersFirebase(){
        
        guard let emailText = emailTextField.text else{return}
        guard let passwordText = passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        let segmentIndex = accountTypeSgmentedControl.selectedSegmentIndex
        let user = User(email: emailText, fullName: fullName, accountType: segmentIndex)
        
        let value = userDictionary(user: user) as! [String: Any]
        
        FUSerListener.shared.creatAccountUser(email: emailText, password: passwordText, value: (value)) { result, error in
            if let error = error {print("Field To Register \(error)");return}
            guard let uid = result?.user.uid else {return}
            
            FUSerListener.shared.sendNotificationOfUser(result: result)
            FDriverListener.shared.saveDriverLocationFirebase(self.accountTypeSgmentedControl.selectedSegmentIndex, uid: uid, location: self.location, value: value)
            
            FUSerListener.shared.saveUserInDataBase(uid: uid, value: value) { error in
                if let error = error {
                    print("Error to Creat new User \(error.localizedDescription)")
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
}
