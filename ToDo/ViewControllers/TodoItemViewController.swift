//
//  TodoItemViewController.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 02/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import UIKit

class TodoItemViewController:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel : TodoItemViewModel!
    var editingIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func changeSortOrder(_ sender: Any) {
        guard let segControl = sender as? UISegmentedControl else {
            return
        }
        
        if self.viewModel.changeSortCriteria(TodoItemViewModel.sortCriteria(rawValue: segControl.selectedSegmentIndex)!) {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTodoItem" {
            let addTaskViewController = segue.destination as! AddTaskViewController
            addTaskViewController.viewModel = self.viewModel
            
            if let editingIndexPath = editingIndexPath {
                addTaskViewController.editingItemId = self.viewModel.getTodoIdForIndexPath(editingIndexPath)
                self.editingIndexPath = nil
            }
        }
    }
}

extension TodoItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getCountForSection(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.titleForSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        
        let (name,priority,date) = self.viewModel.getTodoDataAtIndexPath(indexPath)
        cell.configureCell(title: name, priority: priority, date: date)
        
        return cell
    }
}

extension TodoItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            if self.viewModel.deleteListAtIndexPath(indexPath) {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (editAction, indexPath) -> Void in
            self.editingIndexPath = indexPath
            self.performSegue(withIdentifier: "addTodoItem", sender: nil)
        }
        
        //depending on the section we change the title...
        let doneBtnTitle = indexPath.section == 0 ? "Done" : "Not Done"
        
        let doneAction = UITableViewRowAction(style: .default, title: doneBtnTitle) { (doneAction, indexPath) -> Void in
            guard let newRow = self.viewModel.updateDoneStateForIndexPath(indexPath) else {
                return
            }
            
            if newRow >= 0 {
                let destinationIndexPath = IndexPath(row: newRow, section:indexPath.section == 0 ? 1:0)
                self.tableView.beginUpdates()
                self.tableView.setEditing(false, animated: true)
                self.tableView.moveRow(at: indexPath, to: destinationIndexPath)
                self.tableView.endUpdates()
            }
        }
        
        //we don't show the edit action on completed items
        //also we change the Done button color depending if it's completed or not
        if indexPath.section == 0 {
            doneAction.backgroundColor = UIColor.customBlueColor()
            
            return [deleteAction, editAction, doneAction]
        }
        else {
            doneAction.backgroundColor = UIColor.customDarkGray()
            
            return [deleteAction, doneAction]
        }
    }
}


extension TodoItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.filterByName(searchText)
        self.tableView.reloadData()
    }
}
