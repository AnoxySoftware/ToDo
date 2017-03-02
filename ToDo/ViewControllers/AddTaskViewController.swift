//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 02/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import UIKit

class AddTaskViewController:UIViewController {
  
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySegControl: UISegmentedControl!
    @IBOutlet weak var txtTodoName: UITextField!
    
    var viewModel : TodoItemViewModel?
    var editingItemId : Int?
    
    var btnEnabled : Bool = false {
        didSet {
            self.btnAdd.isEnabled = btnEnabled
            self.btnAdd.backgroundColor = btnEnabled ? UIColor.customBlueColor() :  UIColor.customDarkGray()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        if let editingItemId = editingItemId {
            //we are editing a TODO, get the data of it
            let (name, priority, date) = (self.viewModel?.getTodoDataForId(editingItemId))!
            //fill it in the form
            self.txtTodoName.text = name
            self.prioritySegControl.selectedSegmentIndex = priority - 1
            self.datePicker.date = date
            //update the button text
            self.btnAdd.setTitle("Update Todo", for: .normal)
        }
        else {
            //disable button
            btnEnabled = false
            //set picker min date to now (we don't allow to add expired todo's)
            self.datePicker.minimumDate = Date()
        }
    }
    
    @IBAction func addUpdateTodo(_ sender: Any) {
        //check if we are editing...
        if let editingItemId = editingItemId {
            //we are editing
            self.editTodoWithId(editingItemId)
        }
        else {
            //we are adding a new iem
            self.addNewTodo()
        }
    }
    
    @IBAction func cancelTodo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addNewTodo() {
        if self.viewModel!.addTodoWithName(self.txtTodoName.text!, priority: self.prioritySegControl.selectedSegmentIndex+1, dueDate: self.datePicker.date) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            //an error occured...
            self.showErrorWithMessage("An error occured while trying to add the todo.\nPlease try again and if the problem persists let us know!")
        }
    }
    
    func editTodoWithId(_ id:Int) {
        if self.viewModel!.updateTodoWithName(self.txtTodoName.text!, priority: self.prioritySegControl.selectedSegmentIndex+1, dueDate: self.datePicker.date, id:id) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            //an error occured...
            self.showErrorWithMessage("An error occured while trying to update the todo.\nPlease try again and if the problem persists let us know!")
        }
    }
    
    func showErrorWithMessage(_ msg:String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        self.present(alertController, animated: true, completion: nil)
    }
}


extension AddTaskViewController:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {        
        self.btnEnabled = textField.text!.characters.count > 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        self.btnEnabled = resultString.characters.count > 0
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
