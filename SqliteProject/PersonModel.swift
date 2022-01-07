//
//  PersonModel.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/4.
//

import Foundation

struct Person {
    var idNumber: Int
    var name: String
    var phoneNumber: String
    
    init(idNumber: Int = Int.random(in: 0...2000000000), name: String, phoneNumber: String) {
        self.idNumber = idNumber
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
