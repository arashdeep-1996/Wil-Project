//
//  ForgetPasswordViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/16/22.
//

import UIKit
import Firebase
class ForgetPasswordViewController: UIViewController {
private var showAlert = false
    private var errString: String?
    @IBOutlet weak var email: UITextField!
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        Service.resetPassword(email: email.text!) { (result) in
            switch result {
            case .failure(let error):
                self.errString = error.localizedDescription
            case .success( _):
                break
            }
            Service.createAlertController(title: "Successful", message: "Your password reset mail is sent.")
            
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
