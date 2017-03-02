//
//  TodoList.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 01/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import Foundation
import RealmSwift

class TodoList: Object {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var createdAt = Date()
    let todoItems = List<TodoItem>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
