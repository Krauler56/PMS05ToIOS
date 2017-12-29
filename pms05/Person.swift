//
//  Person.swift
//  pms05
//
//  Created by Пользователь on 29.12.2017.
//  Copyright © 2017 Пользователь. All rights reserved.
//

import Foundation
class Persons:Codable{
    let persons:[Person]
    init(persons:[Person])
    {
        self.persons=persons
    }
}
class Person:Codable{
    let _id :String
    let firstName:String
    let lastName:String
    let email:String
    let password :String
    let roles:String
    init (_id:String,firstName:String,lastName:String,email:String,password:String,roles:String)
    {
        self._id=_id
        self.firstName=firstName
        self.lastName=lastName
        self.email=email
        self.password=password
        self.roles=roles
    }
}
