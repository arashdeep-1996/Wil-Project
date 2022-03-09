//
//  ProfileViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/1/22.
//
import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var ProfilePhoto: UIImageView!
    @IBOutlet weak var email: UITextField!
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePhoto.layer.borderWidth = 1
        ProfilePhoto.layer.masksToBounds = false
        ProfilePhoto.layer.backgroundColor = UIColor.black.cgColor
        ProfilePhoto.layer.cornerRadius = ProfilePhoto.frame.height/2
        ProfilePhoto.clipsToBounds = true
        fetchUser()
        /*
        let defaults = UserDefaults.standard
        Service.getUserInfo(onSuccess:{
            self.name.text = defaults.string(forKey: "userNameKey")
            self.phNo.text = defaults.string(forKey: "userphoneKey")
            self.email.text = defaults.string(forKey: "userEmailKey")
        }) { (error) in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
 */
        }
        func fetchUser() {
                Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let user = User(dictionary: dictionary)
                        //self.users.append(user)
                        self.name.text = user.name
                        self.email.text = user.email
                        
                        
                        
                        if let profileImageUrl = user.profileImageUrl {
                            self.ProfilePhoto.loadImageUsingCacheWithUrlString(profileImageUrl)
                        }                    }
                    
                    }, withCancel: nil)
            }
    
   

    /*r
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
