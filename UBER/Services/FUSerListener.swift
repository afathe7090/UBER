//
//  FUSerListener.swift
//  UBER
//
//  Created by Ahmed Fathy on 01/10/2021.
//

import Firebase
import UIKit

class FUSerListener{
    
    static let shared = FUSerListener()
    
    //MARK: - Sign iN
    func userSignIn(email: String , password: String, complation: @escaping (AuthDataResult? , Error?)->Void){
        
        Auth.auth().signIn(withEmail: email, password: password, completion: complation)
    }
    
    
    //MARK: - creat New Account
    func creatAccountUser(email: String , password: String , value: [String: Any], completion:@escaping(AuthDataResult?, Error? )-> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    
    
    //MARK: - Send Notifications
    func sendNotificationOfUser(result: AuthDataResult?){
        result!.user.sendEmailVerification { error in
            if error != nil{print("Can't Send Varification Code!!!!!!")}
        }
    }
    
    
    //MARK: - save Data To Fire Base
    func saveUserInDataBase(uid: String , value: [String: Any] , complation: @escaping(Error?) -> Void){
        REF_USRS.child(uid).updateChildValues(value) { (error, ref )in
            complation(error)
        }
    }
    

    //MARK: - Fetch User Data
    func fetchUserData(uid: String,complition: @escaping(User)-> Void){
        REF_USRS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else{return}
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            complition(user)
        }
    }
    
    
    
}

