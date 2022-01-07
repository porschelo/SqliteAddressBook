//
//  Database.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/5.
//

import Foundation
import SQLite

class Database {
    
    var db: Connection!
    var users: Table!
    var idNumber: Expression<Int>!
    var name: Expression<String>!
    var phoneNumber: Expression<String>!
    
    init(withSqlite dbName: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            db = try Connection("\(path)/\(dbName)")
            
            users = Table("user")
            idNumber = Expression<Int>("idNumber")
            name = Expression<String>("name")
            phoneNumber = Expression<String>("phoneNumber")
            
            try db.run(users.create(ifNotExists: true) { t in
                t.column(idNumber)
                t.column(name)
                t.column(phoneNumber)
            })
            
        } catch {
            print(error)
        }
    }
    
    func insertData(idNumber: Int, name: String, phoneNumber: String) {
        do {
            try db?.run(users.insert(self.idNumber <- idNumber, self.name <- name, self.phoneNumber <- phoneNumber))
        } catch {
            print(error)
        }
        
    }
    
    func removeData(idNumber: Int) {
        do {
            try db?.run(users.filter(self.idNumber == idNumber).delete())
        } catch {
            print(error)
        }
    }
    
    func updateData(idNumber: Int, name: String, phoneNumber: String) {
        do {
            try db?.run(users.filter(self.idNumber == idNumber).update(self.name <- name, self.phoneNumber <- phoneNumber))
        } catch {
            print(error)
        }
    }
    
    func getData() {
        ViewController.dataSource = []
        do {
            if let users = try db?.prepare(users) {
                for user in users {
                    ViewController.dataSource.append(Person(idNumber: user[idNumber], name: user[name], phoneNumber: user[phoneNumber]))
                }
            }
        } catch {
            print(error)
        }
    }
    
}
