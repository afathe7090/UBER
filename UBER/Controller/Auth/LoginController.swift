//
//  LoginController.swift
//  LoginController
//
//  Created by Ahmed Fathy on 06/09/2021.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
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
    private lazy var passwordTextField: UITextField = {
        return UITextField().textField(withPlaceHolder: "password", imageLeft: UIImage(named: "ic_lock_outline_white_2x")!, isSecureTextEntry: true)
    }()
    
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var passwordSeperatorView: UIView = {
        return UIView().handelSeperatorView(passwordTextField)
    }()
    
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView (arrangedSubviews: [emailTextField,passwordTextField ,loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()

    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var loginButton: UIButton = {
        let btn = AuthButton(type: .system)
        btn.setTitle("Log in", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(loginBtnPressedAction), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private lazy var dontHaveAnAccountButton: UIButton = {
       
        let button = UIButton(type: .system)
        
       let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 16) ,.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign UP", attributes: [.font: UIFont.systemFont(ofSize: 16) , .foregroundColor: UIColor.mainBlueTint]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(signUpBtnPressedAction), for: .touchUpInside)
        return button
    }()
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        handelViewController()
        
        handelTitlelabelConstrains()
        
        handelDontHaveAccountButton()
        
        stackViewConstrains()

        LocationHandler.shared.enableLocationsServices() 
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
    //MARK: -  Actions Button
    
    @objc func loginBtnPressedAction(){
        
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        
        Hud.showHud(in: view)
        FUSerListener.shared.userSignIn(email: email, password: password) { result, error in
            if let error = error {print("Can't sign in \(error.localizedDescription)");Hud.dismiss() ;return}
            
            saveCurrentID(Auth.auth().currentUser?.uid)
            self.goingToHome()
            print("Success Login")
        }
    }
    
    
    @objc func signUpBtnPressedAction(){
        let vc = SignUpController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK: - Functions
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> going To Home Controller
    //----------------------------------------------------------------------------------------------------------------
    
    private func goingToHome(){
        Hud.dismiss()
        DispatchQueue.main.async {
            let homeController = HomeController()
            homeController.modalPresentationStyle = .fullScreen
            self.present(homeController, animated: true, completion: nil)
        }
    }
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------
    //=======> Handel View Controller
    //----------------------------------------------------------------------------------------------------------------
    private func handelViewController(){
        view.backgroundColor = .backgoundColor
        view.addSubview(emailSeperatorView)
        view.addSubview(passwordSeperatorView)
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
    private func handelDontHaveAccountButton(){
        view.addSubview(dontHaveAnAccountButton)
        dontHaveAnAccountButton.centerX(inView: view)
        dontHaveAnAccountButton.ancherConstrains(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
    private func stackViewConstrains(){
        view.addSubview(stackView)
        stackView.ancherConstrains(top: titleLabel.bottomAnchor , left: view.leadingAnchor , right: view.trailingAnchor ,paddingTop: 40 ,paddingLeft: 20 ,paddingRight: 20)
    }
}
