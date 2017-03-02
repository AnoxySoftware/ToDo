//
//  TodoItemViewModel.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 02/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItemViewModel {
        
    enum sortCriteria:Int {
        case sortByDate = 0
        case sortByPriority = 1
    }
    
    var todoList : List<TodoItem>!
    
    fileprivate let uiRealm = try! Realm()
    
    var openTasks : Results<TodoItem>!
    var completedTasks : Results<TodoItem>!
    var sortOrder : sortCriteria = .sortByDate
    
    let sectionTitles : [String] = ["Open Tasks","Completed Tasks"]
    
    init(_ list:TodoList) {
        self.todoList = list.todoItems
        
        self.completedTasks = list.todoItems.filter("isCompleted = true")
            .sorted(byKeyPath: "createdAt", ascending:false)
        
        self.openTasks = list.todoItems.filter("isCompleted = false")
            .sorted(byKeyPath: "createdAt", ascending:false)
    }
    
    func addTodoWithName(_ name:String, priority:Int, dueDate:Date) -> Bool {
        let todo = TodoItem()
        todo.id = self.incrementID()
        
        return self.configureTodo(todo: todo, name: name, priority: priority, dueDate: dueDate, update: false)
    }
    
    func updateTodoWithName(_ name:String, priority:Int, dueDate:Date, id:Int) -> Bool {
        let todo : TodoItem = uiRealm.object(ofType: TodoItem.self, forPrimaryKey: id)!
        return self.configureTodo(todo: todo, name: name, priority: priority, dueDate: dueDate, update: true)
    }
    
    private func configureTodo(todo:TodoItem,name:String, priority:Int, dueDate:Date,update:Bool) -> Bool {
        
        do {
            try uiRealm.write {
                
                todo.name = name
                todo.dueDate = dueDate
                todo.priority = priority
                
                uiRealm.add(todo, update: update)
                
                if !update {
                    self.todoList.append(todo)
                }
            }
        }
        catch let error {
            print("Error during adding/updating Todo: \(error)")
            return false
        }
        return true
    }
    
    func getTodoDataForId(_ id:Int) -> (String, Int, Date) {
        let todo : TodoItem = uiRealm.object(ofType: TodoItem.self, forPrimaryKey: id)!
        return (todo.name, todo.priority, todo.dueDate)
    }
    
    func getTodoIdForIndexPath(_ indexPath: IndexPath) -> Int {
        let todoItem = self.getTodoAtIndexPath(indexPath)
        return todoItem.id
    }
    
    func numberOfSections() -> Int {
        return sectionTitles.count
    }
    
    func titleForSection(_ section:Int) -> String {
        return sectionTitles[section]
    }
    
    func changeSortCriteria(_ sortCriteria:sortCriteria) {
        self.sortOrder = sortCriteria
        
        switch sortCriteria {
        case .sortByDate:
            self.completedTasks = self.completedTasks.sorted(byKeyPath: "createdAt", ascending:false)
            self.openTasks = self.openTasks.sorted(byKeyPath: "createdAt", ascending:false)
        case .sortByPriority:
            self.completedTasks = self.completedTasks.sorted(byKeyPath: "priority", ascending:false)
            self.openTasks = self.openTasks.sorted(byKeyPath: "priority", ascending:false)
        }
    }
    
    func getCountForSection(_ section:Int) -> Int {
        switch section {
        case 0:
            return self.openTasks.count
        case 1:
            return self.completedTasks.count
        default:
            return 0
        }
    }
        
    func deleteTodoAtIndexPath(_ indexPath: IndexPath) -> Bool {
        let todoItem = self.getTodoAtIndexPath(indexPath)
        self.uiRealm.beginWrite()
        self.uiRealm.delete(todoItem)
        
        do {
            try self.uiRealm.commitWrite()
        }
        catch let error {
            print("Error during deleteListAtIndexPath: \(error)")
            return false
        }
        return true
    }
    
    func updateDoneStateForIndexPath(_ indexPath: IndexPath) -> Int? {
        let todo = self.getTodoAtIndexPath(indexPath)
        
        do {
            try uiRealm.write{
                todo.isCompleted = !todo.isCompleted
                uiRealm.add(todo, update: true)
            }
        }
        catch let error {
            print("Error during change of Todo completion state: \(error)")
            return nil
        }
        
        if indexPath.section == 0 {
            return self.completedTasks.index(of: todo)
        }
        else {
            return self.openTasks.index(of: todo)
        }
    }
    
    func getTodoDataAtIndexPath(_ indexPath:IndexPath) -> (String,Int,Date) {
        let todo = self.getTodoAtIndexPath(indexPath)
        return (todo.name,todo.priority,todo.dueDate)
    }
    
    func filterByName(_ name:String) {
        let sortKeypath = self.sortOrder == .sortByDate ? "createdAt" : "priority"
        
        self.completedTasks = self.todoList.filter(NSPredicate(format: "isCompleted = true AND name BEGINSWITH[c] '\(name)'"))
            .sorted(byKeyPath: sortKeypath, ascending:false)
        
        self.openTasks = self.todoList.filter(NSPredicate(format: "isCompleted = false AND name BEGINSWITH[c] '\(name)'"))
            .sorted(byKeyPath: sortKeypath, ascending:false)
    }
    
    func getTodoAtIndexPath(_ indexPath:IndexPath) -> TodoItem {
        if indexPath.section == 0 {
            return self.openTasks[indexPath.row]
        }
        else {
            return self.completedTasks[indexPath.row]
        }
    }
    
    func incrementID() -> Int {
        return (uiRealm.objects(TodoItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
