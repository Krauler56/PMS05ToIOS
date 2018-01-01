//
//  Project.swift
//  pms05
//
//  Created by Пользователь on 30.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import Foundation
class Project:Codable{
    var _id :String?
    var name:String?
    var description:String?
    var managerId:String?
    var manager :[Person]?
    init (_id:String,name:String,description:String,managerId:String,manager:[Person])
    {
        self._id=_id
        self.name=name
        self.description=description
        self.managerId=managerId
        self.manager=manager
    }
    func setNameDescManager(name:String,description:String,manager:[Person])->Void
    {
        self.name=name
        self.description=description
        self.manager=manager
        managerId=self.manager![0]._id!
    }
}
class ProjectInsertClass:Codable
{
    var _id:String
    var name:String
    var description:String
    var managerId:String
    init(name:String,description:String,managerId:String,_id:String)
    {
        self._id=_id
        self.name=name
        self.description=description
        self.managerId=managerId
    }
    
    
}
