//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Eleftherios Charitou on 01/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import XCTest
import RealmSwift
@testable import ToDo

class ToDoTests: XCTestCase {
    var todoListViewModel: MockTodoListViewModel!
    var todoItemViewModel: MockTodoItemViewModel!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        // Put setup code here. This method is called before the invocation of each test method in the class.
        todoListViewModel = MockTodoListViewModel()
        
        _ = todoListViewModel.addTodoListWithName("OwningListTest_rndm")
        let indexPath = IndexPath(row: 0, section: 0)
        let todoList : TodoList = todoListViewModel.getTodoListAtIndexPath(indexPath)
        todoItemViewModel = MockTodoItemViewModel(todoList)
    }
    
    override func tearDown() {
        todoListViewModel = nil
        todoItemViewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: TodoListViewModel Tests
    
    func testCreatingTodoList() {
        let todoList : TodoList = TodoList()
        let creationDate = Date()
        todoList.name = "Test1"
        todoList.createdAt = creationDate
        
        XCTAssertNotNil(todoList, "A TodoList should be created with valid data")
        XCTAssertEqual(todoList.name, "Test1", "TodoList name didn't match assigned value!")
        XCTAssertEqual(todoList.createdAt, creationDate, "Creation Date didn't match assigned value!")
    }
    
    func testCreatingTodoItem() {
        let todoItem: TodoItem = TodoItem()
        let creationDate = Date()
        let dueDate = Date(timeIntervalSinceNow:3600)
        
        todoItem.name = "Test2"
        todoItem.createdAt = creationDate
        todoItem.dueDate = dueDate
        todoItem.priority = 3
        
        XCTAssertNotNil(todoItem, "A TodoItem should be created with valid data")
        XCTAssertEqual(todoItem.name, "Test2", "TodoItem name didn't match assigned value!")
        XCTAssertEqual(todoItem.createdAt, creationDate, "Creation Date didn't match assigned value!")
        XCTAssertEqual(todoItem.dueDate, dueDate, "Due Date didn't match assigned value!")
        XCTAssertEqual(todoItem.priority, 3, "Priority didn't match assigned value!")
    }
    
    func testAddingList() {
        let listId = todoListViewModel.addTodoListWithName("Test")
        XCTAssertNotEqual(listId, -1, "Failed adding TodoList")
    }
    
    func testDeletingListAtIndexPath() {
        _ = todoListViewModel.addTodoListWithName("Test3")
        let indexPath = IndexPath(row: 0, section: 0)
        let successDelete = todoListViewModel.deleteListAtIndexPath(indexPath)
        XCTAssertEqual(successDelete, true, "Failed deleting TodoList at IndexPath")
    }
    
    func testUpdatingListAtIndexPath() {
        _ = todoListViewModel.addTodoListWithName("Test4")
        let indexPath = IndexPath(row: 0, section: 0)
        let successUpdate = todoListViewModel.updateListAtIndexPath(indexPath, newName: "newTest")
        XCTAssertEqual(successUpdate, true, "Failed updating TodoList at IndexPath")
        
        //get the TodoItem
        let (name,_) = todoListViewModel.getListNameAndIdAtIndexPath(indexPath)
        XCTAssertEqual(name, "newTest", "Failed updating TodoList name")
        
    }
    
    func testTodoListFetchAndCount() {
        _ = todoListViewModel.addTodoListWithName("Test5")
        let indexPath = IndexPath(row: 0, section: 0)
        
        let todoItem: TodoItem = TodoItem()
        let dueDate = Date(timeIntervalSinceNow:3600)
        
        todoItem.name = "Test"
        todoItem.dueDate = dueDate
        todoItem.priority = 3
        todoItem.id = todoItemViewModel.incrementID()
        
        let todoList = todoListViewModel.getTodoListAtIndexPath(indexPath)
        
        XCTAssertNotNil(todoList, "A todoList should be returned")
        
        //add the new Todo
        let successAdd = todoListViewModel.addTodoItem(todoItem, list:todoList)
        
        XCTAssertEqual(successAdd, true, "Failed adding Todo Item to List")
        //check count
        XCTAssertEqual(todoList.todoItems.count, 1, "Failed adding Todo Item to List")
        
        //get count from ViewModel
        let (_,count) = todoListViewModel.getListNameAndTodoCountAtIndexPath(indexPath)
        XCTAssertEqual(count, 1, "Failed adding Todo Item to List")
    }
    
    //MARK: TodoItemViewModel Tests
    func testAddingTodo() {
        let dueDate = Date(timeIntervalSinceNow:3600)
        let success = todoItemViewModel.addTodoWithName("Test",priority: 3,dueDate: dueDate)
        XCTAssertEqual(success, true, "Failed creating Todo Item")
    }
    
    func testUpdatingTodo() {
        let dueDate = Date(timeIntervalSinceNow:21600)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        _ = todoItemViewModel.addTodoWithName("Test",priority: 3,dueDate: dueDate)
        
        let todoItem : TodoItem = todoItemViewModel.getTodoAtIndexPath(indexPath)
        
        let success = todoItemViewModel.updateTodoWithName("NewTest",priority: 5,dueDate: dueDate,id:todoItem.id)
        XCTAssertEqual(success, true, "Failed updating Todo Item")
    }
    
    func testFetchingUpdatedTodo() {
        let dueDate = Date(timeIntervalSinceNow:21600)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        _ = todoItemViewModel.addTodoWithName("Test",priority: 3,dueDate: dueDate)
        
        let todoItem : TodoItem = todoItemViewModel.getTodoAtIndexPath(indexPath)
        
        _ = todoItemViewModel.updateTodoWithName("NewTest",priority: 5,dueDate: dueDate,id:todoItem.id)
        
        let (name,priority,date) = todoItemViewModel.getTodoDataAtIndexPath(indexPath)
        
        XCTAssertEqual(name, "NewTest", "Failed updating Todo Item")
        XCTAssertEqual(priority, 5, "Failed updating Todo Item")
        XCTAssertEqual(date, dueDate, "Failed updating Todo Item")
    }
    
    func testTodoDone() {
        todoItemViewModel.addMockItems()
        
        let index1 = todoItemViewModel.updateDoneStateForIndexPath(IndexPath(row: 3, section: 0))
        let index2 = todoItemViewModel.updateDoneStateForIndexPath(IndexPath(row: 3, section: 0))
        
        XCTAssertEqual(index1,0, "A valid Index should be returned")
        XCTAssertEqual(index2,1, "A valid Index should be returned")
    }
    
    func testTodoSectionCount() {
        todoItemViewModel.addMockItems()
        todoItemViewModel.moveFirst2ToCompleted()
        
        XCTAssertEqual(todoItemViewModel.getCountForSection(0),3, "Section items should be 3 for section 0")
        XCTAssertEqual(todoItemViewModel.getCountForSection(1),2, "Section items should be 2 for section 1")
    }
    
    func testSortingByPriority() {
        todoItemViewModel.addMockItems()
        todoItemViewModel.moveFirst2ToCompleted()
        
        //sort by priority
        todoItemViewModel.changeSortCriteria(.sortByPriority)
        
        //verify item position...
        let name1 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 0, section: 0))
        let name2 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 1, section: 0))
        let name3 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 2, section: 0))
        let name4 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 0, section: 1))
        let name5 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 1, section: 1))
        
        XCTAssertEqual(name1,"Test3", "First Item should be Test3")
        XCTAssertEqual(name2,"Test", "Second Item should be Test")
        XCTAssertEqual(name3,"Test2", "Thirs Item should be Test2")
        XCTAssertEqual(name4,"Completed1", "First Item In Section 2 should be Completed1")
        XCTAssertEqual(name5,"Completed2", "Second Item In Section 2 should be Completed2")
    }
    
    func testSortingByDate() {
        todoItemViewModel.addMockItems()
        todoItemViewModel.moveFirst2ToCompleted()
        
        //sort by priority
        todoItemViewModel.changeSortCriteria(.sortByDate)
        
        //verify item position...
        let name1 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 0, section: 0))
        let name2 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 1, section: 0))
        let name3 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 2, section: 0))
        let name4 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 0, section: 1))
        let name5 = todoItemViewModel.getTodoNameAtIndexPath(IndexPath(row: 1, section: 1))
        
        XCTAssertEqual(name1,"Test3", "First Item should be Test3")
        XCTAssertEqual(name2,"Test2", "Second Item should be Test2")
        XCTAssertEqual(name3,"Test", "Third Item should be Test")
        XCTAssertEqual(name4,"Completed2", "First Item In Section 2 should be Completed2")
        XCTAssertEqual(name5,"Completed1", "Second Item In Section 2 should be Completed1")
    }
    
    
    func testFiltering() {
        todoItemViewModel.addMockItems()
        todoItemViewModel.moveFirst2ToCompleted()
        
        let dueDate = Date(timeIntervalSinceNow:21600)
        //add additional items
        _ = todoItemViewModel.addTodoWithName("Test33",priority: 2,dueDate: dueDate)
        _ = todoItemViewModel.addTodoWithName("Test331",priority: 2,dueDate: dueDate)
        _ = todoItemViewModel.updateDoneStateForIndexPath(IndexPath(row: 0, section: 0))
        
        todoItemViewModel.filterByName("Test3")
        
        //verify results
        
        let section1ItemCount = todoItemViewModel.getCountForSection(0)
        let section2ItemCount = todoItemViewModel.getCountForSection(1)
        
        XCTAssertEqual(section1ItemCount,2, "First section count should be 2")
        XCTAssertEqual(section2ItemCount,1, "Second section count should be 1")
    }
    
    func testDeleteList() {
        todoItemViewModel.addMockItems()
        let success = todoItemViewModel.deleteTodoAtIndexPath(IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(success,true, "Failed to delete todo at Indexpath")
        
        let section1ItemCount = todoItemViewModel.getCountForSection(0)
        XCTAssertEqual(section1ItemCount,4, "First section count should be 4")
    }
}

class MockTodoListViewModel: TodoListViewModel {
    
    fileprivate let uiRealm = try! Realm()
    
    func addTodoItem(_ item:TodoItem, list:TodoList) -> Bool {
        do {
            try uiRealm.write{
                list.todoItems.append(item)
            }
        }
        catch let error {
            print("Error during addTodoList: \(error)")
            return false
        }
        
        return true
    }
    
}

class MockTodoItemViewModel: TodoItemViewModel {
    
    fileprivate let uiRealm = try! Realm()
    
    func removeAllTodoItems() {
        do {
            try uiRealm.write{
                self.todoList.removeAll()
            }
        }
        catch let error {
            print("Error during removal of all Todo's: \(error)")
        }
    }
    
    func getTodoNameAtIndexPath(_ indexPath:IndexPath) -> String {
        let todoItem = self.getTodoAtIndexPath(indexPath)
        return todoItem.name
    }
    
    func addMockItems() {
        let dueDate = Date(timeIntervalSinceNow:21600)
        self.removeAllTodoItems()
        
        _ = self.addTodoWithName("Test",priority: 3,dueDate: dueDate)
        _ = self.addTodoWithName("Test2",priority: 1,dueDate: dueDate)
        _ = self.addTodoWithName("Test3",priority: 5,dueDate: dueDate)
        
        _ = self.addTodoWithName("Completed1",priority: 4,dueDate: dueDate)
        _ = self.addTodoWithName("Completed2",priority: 2,dueDate: dueDate)
    }
    
    func moveFirst2ToCompleted() {
        //move the last 2 entries to completed
        //remember the items are added in reverse order (last added --> First on index)
        _ = self.updateDoneStateForIndexPath(IndexPath(row: 0, section: 0))
        _ = self.updateDoneStateForIndexPath(IndexPath(row: 0, section: 0))
    }
    
    func incrementID() -> Int {
        return (uiRealm.objects(TodoItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

