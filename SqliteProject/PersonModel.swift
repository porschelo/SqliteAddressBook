//
//  PersonModel.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/4.
//

import Foundation

struct Person {
    var name: String
    var phoneNumber: String
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
