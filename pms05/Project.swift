//
//  Project.swift
//  pms05
//
//  Created by Пользователь on 30.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import Foundation
class Project:Codable{
    let _id :String
    let name:String
    let description:String
    let managerId:String
    let manager :[Person]
    init (_id:String,name:String,description:String,managerId:String,manager:[Person])
    {
        self._id=_id
        self.name=name
        self.description=description
        self.managerId=managerId
        self.manager=manager
    }
    
}
