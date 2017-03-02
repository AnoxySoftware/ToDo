//
//  TodoItem.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 01/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import Foundation
import RealmSwift


class TodoItem: Object {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var createdAt = Date()
    dynamic var dueDate = Date()
    dynamic var priority = 1
    dynamic var isCompleted = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
