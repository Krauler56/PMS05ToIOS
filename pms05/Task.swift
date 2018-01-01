//
//  Task.swift
//  pms05
//
//  Created by Пользователь on 01.01.2018.
//  Copyright © 2018 Пользователь. All rights reserved.
//

import Foundation
class Task :Codable
{
    var _id : String?
    var projectId: String?
    var description:String?
    var workersIds:[String]?
    //var dependsOnIds:[String]
    var deadline: String?
    var status :Int?
    var project : [ProjectInsertClass]?
    var managerId :[String]?
    var manager : [Person]?
    var workers : [Person]?
    var dependsOn:[Task]?
    init(_id:String,projectId:String,description:String,workersIds:[String],/*dependsOnIds:[String],*/deadline:String,
         status:Int,project:[ProjectInsertClass],managerId:[String],manager:[Person],workers:[Person],dependsOn:[Task])
    {
        self._id=_id
        self.projectId=projectId
        self.description=description
        self.workersIds=workersIds
        //self.dependsOnIds=dependsOnIds
        self.deadline=deadline
        self.status=status
        self.project=project
        self.managerId=managerId
        self.manager=manager
        self.workers=workers
        self.dependsOn=dependsOn
    }

}
class TaskToEdit:Codable
{
    var _id:String?
    var status:Int?
    var managerId :[String]?
    var deadline: String?
    var description:String?
    var workersIds:[String]?
    var projectId:String?
    init(_id:String,projectId:String,description:String,workersIds:[String],deadline:String,
         status:Int,managerId:[String])
    {
        self._id=_id
        self.status=status
        self.managerId=managerId
        self.deadline=deadline
        self.description=description
        self.workersIds=workersIds
        self.projectId=projectId
        
    }
    
}
