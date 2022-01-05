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
    var id: Expression<Int64>!
    var name: Expression<String>!
    var phoneNumber: Expression<String>!
    
    init(withSqlite dbName: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            db = try Connection("\(path)/\(dbName)")
            
            users = Table("user")
            id = Expression<Int64>("id")
            name = Expression<String>("name")
            phoneNumber = Expression<String>("phoneNumber")
            
            try db.run(users.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(phoneNumber)
            })
            
        } catch {
            print(error)
        }
    }
    
    func insertData(name: String, phoneNumber: String) {
        do {
            try db?.run(users.insert(self.name <- name, self.phoneNumber <- phoneNumber))
        } catch {
            print(error)
        }
        
    }
    
    func removeData(dataId: Int64) {
        do {
            try db?.run(users.filter(id == dataId).delete())
        } catch {
            print(error)
        }
    }
    
    func getData() {
        do {
            if let users = try db?.prepare(users) {
                for user in users {
                    ViewController.dataSource = []
                    ViewController.dataSource.append(Person(name: user[name], phoneNumber: user[phoneNumber]))
                }
            }
        } catch {
            print(error)
        }
    }
    
}
