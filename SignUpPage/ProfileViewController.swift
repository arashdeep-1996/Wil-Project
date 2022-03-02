//
//  ProfileViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/1/22.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phNo: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        Service.getUserInfo(onSuccess:{
            self.name.text = defaults.string(forKey: "userNameKey")
            self.phNo.text = defaults.string(forKey: "userphoneKey")
            self.email.text = defaults.string(forKey: "userEmailKey")
        }) { (error) in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
