//
//  Service.swift
//  SignUpPage
//
//  Created by user206151 on 3/1/22.
//

import UIKit
import Firebase
class Service{
    static func signupUser(email: String, password: String,name: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void){
        let auth = Auth.auth()
        auth.createUser(withEmail: email, password: password){(authResult, err) in
            if err != nil {
                onError(err!)
                //self.present(Service.createAlertController(title: "Error", message: err!.localizedDescription), animated: true, completion: nil)
                return
            }
            
uploadToDatabase(email: email, name: name, password: password, onSuccess: onSuccess)
        }
        
    }
    static func uploadToDatabase(email: String, name: String,password: String, onSuccess: @escaping () -> Void){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).setValue(["email" : email, "name" : name, "password" : password])
        onSuccess()
    }
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok", style: .default){ (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(OKAction)
        return alert
    }
}
