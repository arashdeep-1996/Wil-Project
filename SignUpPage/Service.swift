//
//  Service.swift
//  SignUpPage
//
//  Created by user206151 on 3/1/22.
//

import UIKit
import Firebase

class User: NSObject {
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var taskGroup: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.taskGroup = dictionary["task group name"] as? String
    }
    
}
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}
class Service{
    
    static func getUserInfo(onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void){
        let ref = Database.database().reference()
        let defaults = UserDefaults.standard
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return
        }
        ref.child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionarys = snapshot.value as? [String : Any] {
                
                let email = dictionarys["email"] as! String
                let name = dictionarys["name"] as! String
                let phone = dictionarys["PhoneNo"] as! String
                let image = dictionarys["profileImageUrl"] as! URL
                defaults.set(email, forKey: "userEmailKey")
                defaults.set(name, forKey: "userNameKey")
                defaults.set(phone, forKey: "userphoneKey")
                defaults.setValue(image, forKey: "profileImageUrl")
                onSuccess()
            }
        }) { (error) in
            onError(error)
        }
    }
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok", style: .default){ (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(OKAction)
        return alert
    }
    static func resetPassword(email: String, resetCompletion: @escaping (Result<Bool,Error>) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                resetCompletion(.failure(error))
            } else {
                resetCompletion(.success(true))
            }
        })
    }
}
