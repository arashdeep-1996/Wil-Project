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
struct todoList{
    var taskGroup: String
    
}
class TaskGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addTaskGroup: UIButton!
    @IBOutlet weak var deleteTaskGroup: UIButton!
    var databaseRef: DatabaseReference?
    var user = [User]()
    var todolist: [todoList] = []
   
    let uid = Auth.auth().currentUser?.uid
    func nonDeletedNotes() -> [todoList]
        {
            var noDeleteNoteList = [todoList]()
            for note in todolist
            {
                    noDeleteNoteList.append(note)
            }
            return noDeleteNoteList
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        fetchUser()
        loadGroup()
    }
    func fetchUser() {
        
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    self.name.text = user.name
                    self.email.text = user.email
                    if let profileImageUrl = user.profileImageUrl {
                        self.userImage.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }                    }
                
                }, withCancel: nil)
              }
    func loadGroup(){
        let ref = Database.database().reference(withPath: "users").child(uid!).child("task group")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let todoName = child.key
                let todoRef = ref.child(todoName)
                todoRef.observeSingleEvent(of: .value, with: { (todoSnapshot) in
                    let value = todoSnapshot.value as? NSDictionary
                    self.todolist.append(todoList(taskGroup: todoName))
                    self.tableView.reloadData()
                    
                })
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolist.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            
            let cell:CellTaskGroup = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellTaskGroup
            cell.lbl.text = todolist[indexPath.row].taskGroup
            return cell
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let ref = Database.database().reference(withPath: "users").child(uid!).child("task group").child(todolist[indexPath.row].taskGroup)
            ref.removeValue()
            todolist.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    @IBAction func addTaskGroup(_ sender: Any) {
        //self.performSegue(withIdentifier: "addTaskGroup", sender: nil)
        let todoAlert = UIAlertController(title: "New Group", message: "Add new task group", preferredStyle: .alert)
        todoAlert.addTextField()
        let addtodoAction = UIAlertAction(title: "Add", style: .default){ (action) in
            
            let todoText = todoAlert.textFields![0].text
            self.todolist.append(todoList(taskGroup: todoText!))
            let ref = Database.database().reference().child("users").child(self.uid!).child("task group")
            ref.child(todoText!).setValue(["isChecked" : false])
            self.tableView.reloadData()
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        todoAlert.addAction(addtodoAction)
        todoAlert.addAction(cancelAction)
        present(todoAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
            {
                self.performSegue(withIdentifier: "addTask", sender: self)
            }
}
