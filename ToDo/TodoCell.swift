//
//  TodoCell.swift
//  ToDo
//
//  Created by Eleftherios Charitou on 02/03/17.
//  Copyright © 2017 Anoxy Software. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(title:String, priority:Int, date:Date) {
        self.titleLabel.text = title
        self.dateLabel.text = self.stringFromDate(date)
        
        let (title,color) = self.priorityFormat(priority)
        self.priorityLabel.text = title
        self.priorityLabel.textColor = color
    }
    
    func stringFromDate(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:MM"
        return dateFormatter.string(from: date)
    }
    
    func priorityFormat(_ priority:Int) -> (String,UIColor) {
        switch priority {
        case 1:
            return ("VERY LOW", UIColor.black)
        case 2:
            return ("LOW",UIColor.darkGray)
        case 3:
            return ("MEDIUM",UIColor.customBlueColor())
        case 4:
            return ("HIGH",UIColor.customRedColor())
        case 5:
            return ("VERY HIGH",UIColor.red)
        default:
            return ("",UIColor.black)
        }
    }
}
