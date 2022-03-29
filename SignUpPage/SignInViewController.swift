//
//  SignInViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/1/22.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signin(_ sender: Any) {
        let auth = Auth.auth()
        auth.signIn(withEmail: email.text!, password: password.text!){(authResult, err) in
            if err != nil {
                self.present(Service.createAlertController(title: "Error", message: err!.localizedDescription), animated: true, completion: nil)
                return
            }
            
        }
        self.performSegue(withIdentifier: "Home", sender: nil)    }
}
