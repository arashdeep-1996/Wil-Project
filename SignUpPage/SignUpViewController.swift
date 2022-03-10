//
//  SignUpViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/1/22.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
class SignUpViewController: UIViewController{
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.backgroundColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }

    @objc func handleSelectProfileImageView() {
       /*let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)*/
        actionSheet()
    }
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func actionSheet(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "open camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (handler) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.sourceType = .camera
            image.mediaTypes = [kUTTypeImage as String]
            self.present(image, animated: true, completion: nil)
        }
    }
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.delegate = self
            self.present(image, animated: true, completion: nil)
        }
        
    }
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = usernameTextField.text else {
                   print("Form is not valid")
                   return
               }
               
               Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
                   
                   if let error = error {
                       print(error)
                       return
                   }
                   
                   guard let uid = res?.user.uid else {
                       return
                   }
                   
                   //successfully authenticated user
                   let imageName = NSUUID().uuidString
                   let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                   
                   if let uploadData = self.profileImage.image!.pngData() {
                       
                       storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                           
                           if let error = error {
                               print(error)
                               return
                           }
                           
                           storageRef.downloadURL(completion: { (url, err) in
                               if let err = err {
                                   print(err)
                                   return
                               }
                               
                               guard let url = url else { return }
                            let values = ["name": name, "email": email, "profileImageUrl": url.absoluteString]
                               
                            let alert = UIAlertController(title: "Successfully created", message: "You are a new user of this app.", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "ok", style: .default){ (action) in
                                alert.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(OKAction)
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                           })
                           
                       })
                   }
               })
                              }

               private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
                       let ref = Database.database().reference(fromURL: "https://ontodo-9e1be-default-rtdb.firebaseio.com/")
                       let usersReference = ref.child("users").child(uid)
                       
                       usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                           
                           if let err = err {
                               print(err)
                               return
                           }
                        self.performSegue(withIdentifier: "done", sender: nil)
                        self.dismiss(animated: true, completion: nil)
                       })
                   }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

            
            var selectedImageFromPicker: UIImage?
            
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                selectedImageFromPicker = editedImage
            } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                
                selectedImageFromPicker = originalImage
            }
            
            if let selectedImage = selectedImageFromPicker {
                profileImage.image = selectedImage
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("canceled picker")
            dismiss(animated: true, completion: nil)
        }
        
    

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

}


/*Service.signupUser(email: email.text!, password: password.text!, name: Uname.text!, phoneNo: PNo.text!,onSuccess:  {
            self.performSegue(withIdentifier: "signIn", sender: nil)
             
        }) { (err) in
            self.present(Service.createAlertController(title: "Error", message: err!.localizedDescription), animated: true, completion: nil)
        }*/
