//
//  SignUpViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/1/22.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    @IBOutlet weak var Uname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func signup(_ sender: Any) {
        Service.signupUser(email: email.text!, password: password.text!, name: Uname.text!, onSuccess:  {
            self.performSegue(withIdentifier: "signIn", sender: nil)
        }) { (err) in
            self.present(Service.createAlertController(title: "Error", message: err!.localizedDescription), animated: true, completion: nil)
        }

        
    
    }
    
}
