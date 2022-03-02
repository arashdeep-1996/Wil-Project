//
//  UpdateViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/2/22.
//

import UIKit
import MobileCoreServices
class UpdateViewController: UIViewController {
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var updatebutton: UIButton!
    @IBOutlet weak var ProfilePhoto: UIImageView!
    @IBOutlet weak var phNo: UITextField!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePhoto.layer.borderWidth = 1
        ProfilePhoto.layer.masksToBounds = false
        ProfilePhoto.layer.backgroundColor = UIColor.black.cgColor
        ProfilePhoto.layer.cornerRadius = ProfilePhoto.frame.height/2
        ProfilePhoto.clipsToBounds = true
      
        
        let defaults = UserDefaults.standard
        Service.getUserInfo(onSuccess:{
            self.name.text = defaults.string(forKey: "userNameKey")
            self.phNo.text = defaults.string(forKey: "userphoneKey")
        }) { (error) in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
        }        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickImage(_ sender: Any) {
        actionSheet()
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
    /*
    // MARK: - Navigation

    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func UpdateAction(_ sender: Any) {
        
    }
    
}
extension UpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let editingImage = info[UIImagePickerController.InfoKey(rawValue: convertInfoKey(UIImagePickerController.InfoKey.editedImage))] as? UIImage{
            print(editingImage)
            self.ProfilePhoto.image = editingImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true,completion: nil)
    }
    func convertFromUIimageToDict( _ input :[UIImagePickerController.InfoKey : Any]) -> [String : Any]{
        return Dictionary(uniqueKeysWithValues: input.map({ key , value in (key.rawValue, value)}))
    }
    func convertInfoKey( _ input : UIImagePickerController.InfoKey) -> String{
        return input.rawValue
    }
}
