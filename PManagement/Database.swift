//
//  Database.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import RealmSwift

class Projects: Object {
    
    dynamic var id : String?
    dynamic var name : String?
    dynamic var detail : String?
    
    dynamic var creationDate : Date?
    
    var tasks = List<Tasks>()
    
    dynamic var operationType : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Tasks: Object {
    
    dynamic var id : String?
    dynamic var projectName : String?
    dynamic var title : String?
    dynamic var taskDescription : String?
    dynamic var status : String?
    dynamic var creationDate : Date?
    
    var comments = List<Comments>()
    
    dynamic var operationType : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Comments: Object {
    
    dynamic var id : String?
    dynamic var comment : String?
    dynamic var commentBy : String?
    dynamic var creationDate : Date?
    dynamic var operationType : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
