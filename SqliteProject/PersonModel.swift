//
//  PersonModel.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/4.
//

import Foundation

struct Person {
    var idNumber: Double
    var name: String
    var phoneNumber: String
    
    init(idNumber: Double = Double.random(in: 0...1), name: String, phoneNumber: String) {
        self.idNumber = idNumber
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
