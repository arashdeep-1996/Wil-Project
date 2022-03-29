//
//  AddTaskViewController.swift
//  SignUpPage
//
//  Created by user206151 on 3/29/22.
//

//
//  AddingTaskViewController.swift
//  OnToDo
//
//  Created by Mac on 23/02/22.
//  Copyright © 2022 user206151. All rights reserved.
//

import UIKit
import Firebase
class AddingTaskViewController: UIViewController, UITextViewDelegate {
    
    let status = ["progress","completed"]
    var pickerview = UIPickerView()
   let placeholder = "Task Description"

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var taskDeadline: UITextField!
    @IBOutlet weak var taskStatus: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        taskDeadline.text = formatter.string(from: date)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)),for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        taskDeadline.inputView = datePicker
        pickerview.delegate = self;
                pickerview.dataSource = self;
                taskStatus.inputView = pickerview
        taskDescription.delegate = self
        taskDescription.text = placeholder
        taskDescription.textColor = .lightGray
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if taskDescription.textColor == .lightGray{
            taskDescription.text = ""
            taskDescription.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if taskDescription.text == ""{
            taskDescription.text = placeholder
            taskDescription.textColor = .lightGray
        }
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        taskDeadline.text = formatter.string(from: sender.date)
    }

    @IBAction func saveTask(_ sender: Any) {
        
        if(taskName.text!.isEmpty || taskDescription.text.isEmpty || ((taskDeadline.text?.isEmpty) != nil)){
            let alert = UIAlertController(title: "Error", message: "Please enter all details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        else{
            // Data storing into firebase
            
            var name = taskName.text
            var description = taskDescription.text
            var taskDate = taskDeadline.text
            var taskState = taskStatus.text
            
        }
    }

}
extension AddingTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return status.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return status[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        taskStatus.text = status[row]
        taskStatus.resignFirstResponder()
    }
}
