//
//  TaskGroupViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/22/22.
//

import UIKit
import Firebase
class CellTaskGroup: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class TaskGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskGroup: UIButton!
    @IBOutlet weak var deleteTaskGroup: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
fetchUser()
        // Do any additional setup after loading the view.
    }
    func fetchUser() {
            Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    self.name.text = user.name
                    self.email.text = user.email
                    if let profileImageUrl = user.profileImageUrl {
                        self.userImage.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                }, withCancel: nil)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:CellTaskGroup = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellTaskGroup
            Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    cell.lbl.text = user.taskGroup
                    }
                
                }, withCancel: nil)
           
            return cell
        }
    @IBAction func addTask(_ sender: Any) {
        self.performSegue(withIdentifier: "add task group", sender: nil)
    }
    @IBAction func deleteTask(_ sender: Any) {
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
class TaskGroup: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskGroupName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskGroupName.delegate = self
        // Do any additional setup after loading the view.
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskGroupName.resignFirstResponder()
        return true
    }
    @IBAction func addTaskGroup(_ sender: Any) {
        let databaseRef = Database.database().reference()
        let values = ["task group name" : taskGroupName.text]
        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).childByAutoId().updateChildValues(values as [AnyHashable : Any])    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
