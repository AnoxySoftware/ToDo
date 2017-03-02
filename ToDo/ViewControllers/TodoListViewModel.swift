//
//  TodoListViewModel.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 01/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import Foundation
import RealmSwift

class TodoListViewModel {
    
    var lists : Results<TodoList>!
    fileprivate let uiRealm = try! Realm()
    
    init() {
        self.lists = uiRealm.objects(TodoList.self)
    }
        
    func addTodoListWithName(_ listName:String) -> Bool {
        
        let newTodoList = TodoList()
        newTodoList.name = listName
        newTodoList.id = self.incrementID()
        
        do {
            try uiRealm.write{
                uiRealm.add(newTodoList)
            }
        }
        catch let error {
            print("Error during addTodoList: \(error)")
            return false
        }
        return true
    }
    
    func updateListAtIndexPath(_ indexPath: IndexPath, newName:String) -> Bool {
        do {
            
            let (_, id) = self.getListNameAndIdAtIndexPath(indexPath)
            let existingTodoList : TodoList = uiRealm.object(ofType: TodoList.self, forPrimaryKey: id)!
            
            try uiRealm.write{
                existingTodoList.name = newName
            }
        }
        catch let error {
            print("Error during updateListWithName: \(error)")
            return false
        }
        return true
    }
    
    func deleteListAtIndexPath(_ indexPath: IndexPath) -> Bool {
        let listAtIndexPath = self.lists[indexPath.row]
        self.uiRealm.beginWrite()
        self.uiRealm.delete(listAtIndexPath)
        
        do {
            try self.uiRealm.commitWrite()
        }
        catch let error {
            print("Error during deleteListAtIndexPath: \(error)")
            return false
        }
        return true
    }
    
    func getListNameAndIdAtIndexPath(_ indexPath: IndexPath) -> (String,Int) {
        let listAtIndexPath: TodoList = self.lists[indexPath.row]
        return (listAtIndexPath.name, listAtIndexPath.id)
    }
    
    func getListNameAndTodoCountAtIndexPath(_ indexPath: IndexPath) -> (String,Int) {
        let listAtIndexPath: TodoList = self.lists[indexPath.row]
        return (listAtIndexPath.name, listAtIndexPath.todosList.count)
    }
    
    func getViewModelAtIndexPath(_ indexPath: IndexPath) -> TodoItemViewModel {
        let listAtIndexPath: TodoList = self.lists[indexPath.row]
        let todoItemViewModel = TodoItemViewModel(listAtIndexPath)
        return todoItemViewModel
    }
    
    func getTodoListAtIndexPath(_ indexPath: IndexPath) -> TodoList {
        let listAtIndexPath: TodoList = self.lists[indexPath.row]
        return listAtIndexPath
    }
    
    fileprivate func incrementID() -> Int {
        return (uiRealm.objects(TodoList.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
