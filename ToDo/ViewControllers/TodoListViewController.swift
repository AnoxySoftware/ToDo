//
//  TodoListViewController.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 01/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import UIKit

class TodoListViewController:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isEditingMode = false
    var alertControllerCreateAction:UIAlertAction!
    
    let viewModel : TodoListViewModel! = TodoListViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func toggleEditingMode(_ sender: Any) {
        self.changeEditingMode(isOn:!isEditingMode)
    }
    
    @IBAction func addNewList(_ sender: Any) {
        addOrUpdateTaskList(indexPath:nil)
    }
    
    private func changeEditingMode(isOn:Bool) {
        isEditingMode = isOn
        self.tableView.setEditing(isEditingMode, animated: true)
    }
    
    func addOrUpdateTaskList(indexPath: IndexPath?){
        
        let alertTitle = indexPath != nil ? "Update Tasks List" : "Create New Tasks List"
        let doneBtnTitle = indexPath != nil ? "Update List" : "Create List"
                
        let alertController = UIAlertController(title: alertTitle, message: "Write the name of your tasks list.", preferredStyle: UIAlertControllerStyle.alert)
        
        let createAction = UIAlertAction(title: doneBtnTitle, style: UIAlertActionStyle.default) { _ in
            let listName = alertController.textFields?.first?.text
            
            if let indexPath = indexPath {
                //we are editing
                if self.viewModel.updateListAtIndexPath(indexPath, newName: listName!) {
                    self.tableView.beginUpdates()
                    self.changeEditingMode(isOn:false)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
            else {
                //we are adding a new task
                let existingListcount = self.viewModel.lists.count
                
                if self.viewModel.addTodoListWithName(listName!) >= 0 {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: existingListcount, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
            
            //clear the iVar
            self.alertControllerCreateAction = nil
        }
        
        self.alertControllerCreateAction = createAction
        alertController.addAction(createAction)
        createAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { _ in
            //if we are editing, cancel editing...
            if indexPath != nil {
                self.changeEditingMode(isOn:false)
            }
            
            //clear the iVar
            self.alertControllerCreateAction = nil
        }
        
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: #selector(TodoListViewController.nameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if let indexPath = indexPath {
                let (title, _) = self.viewModel.getListNameAndIdAtIndexPath(indexPath)
                textField.text = title
            }
        }
                
        self.present(alertController, animated: true, completion: nil)
    }
    
    //We enable the create action of the Alert Controller only if the textField is not empty
    func nameFieldDidChange(_ textField:UITextField){
        self.alertControllerCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todoTaskSegue",
            let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            let todoList = self.viewModel.getTodoListAtIndexPath(selectedIndexPath)
            let todoViewController = segue.destination as! TodoItemViewController 
            todoViewController.viewModel = TodoItemViewModel(todoList)
        }
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")
        
        let (title, todoCount) = self.viewModel.getListNameAndTodoCountAtIndexPath(indexPath)
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = "\(todoCount) Todo's"
        
        return cell!
    }
}

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            if self.viewModel.deleteListAtIndexPath(indexPath) {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (editAction, indexPath) -> Void in
            self.addOrUpdateTaskList(indexPath:indexPath)
        }
        
        return [deleteAction, editAction]
    }
}
