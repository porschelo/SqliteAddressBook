//
//  LocalDatabase.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/5.
//

import Foundation
import SQLite

class LocalDatabase {
    
    static var shared: LocalDatabase = {
        let db = LocalDatabase(withSqlite: "contact_person.sqlite3")
        
        return db
    }()
    
    var db: Connection!
    var idNumber: Expression<Int>!
    var name: Expression<String>!
    var phoneNumber: Expression<String>!
    var editingDate: Expression<String>!
    
    // For local_change_id_table
    var localChagneIsAddOrNot:Expression<Bool>!
    
    init(withSqlite dbName: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            db = try Connection("\(path)/\(dbName)")
            
            idNumber = Expression<Int>("idNumber")
            name = Expression<String>("name")
            phoneNumber = Expression<String>("phoneNumber")
            editingDate = Expression<String>("editingDate")
            localChagneIsAddOrNot = Expression<Bool>("localChagneIsAddOrNot")
            
            // For user_information_table
            try db.run(Table("user_information_table").create(ifNotExists: true) { t in
                t.column(idNumber)
                t.column(name)
                t.column(phoneNumber)
                t.column(editingDate)
            })
            
            // For local_change_id_table
            try db.run(Table("local_change_id_table").create(ifNotExists: true) { t in
                t.column(idNumber)
                t.column(name)
                t.column(phoneNumber)
                t.column(editingDate)
                t.column(localChagneIsAddOrNot)
            })
            
        } catch {
            print(error)
        }
    }
    
    func insertData(idNumber: Int, name: String, phoneNumber: String, editingDate: String) {
        do {
            try db?.run(Table("user_information_table").insert(self.idNumber <- idNumber, self.name <- name, self.phoneNumber <- phoneNumber, self.editingDate <- editingDate))
        } catch {
            print(error)
        }
    }
    
    func removeData(idNumber: Int) {
        do {
            try db?.run(Table("user_information_table").filter(self.idNumber == idNumber).delete())
        } catch {
            print(error)
        }
    }
    
    func updateData(idNumber: Int, name: String, phoneNumber: String, editingDate: String) {
        do {
            try db?.run(Table("user_information_table").filter(self.idNumber == idNumber).update(self.name <- name, self.phoneNumber <- phoneNumber, self.editingDate <- editingDate))
        } catch {
            print(error)
        }
    }
    
    func getData() -> [Person] {
        var data: [Person] = []
        do {
            if let users = try db?.prepare(Table("user_information_table")) {
                for user in users {
                    data.append(Person(idNumber: user[idNumber], name: user[name], phoneNumber: user[phoneNumber], editingDate: user[editingDate]))
                }
            }
        } catch {
            print(error)
        }
        return data
    }
    
    // When user add or delete the contact person list without internet
    func insertChangedIdData(idNumber: Int, name: String, phoneNumber: String, editingDate: String, localChagneIsAddOrNot: Bool) {
        do {
            try db?.run(Table("local_change_id_table").insert(self.idNumber <- idNumber, self.name <- name, self.phoneNumber <- phoneNumber, self.editingDate <- editingDate, self.localChagneIsAddOrNot <- localChagneIsAddOrNot))
        } catch {
            print(error)
        }
    }
    
    func getChangedData(isAdded: Bool) -> [Person] {
        var data: [Person] = []
        do {
            if let users = try db?.prepare(Table("local_change_id_table")) {
                for user in users {
                    // get added data
                    if isAdded && user[localChagneIsAddOrNot] {
                        data.append(Person(idNumber: user[idNumber], name: user[name], phoneNumber: user[phoneNumber], editingDate: user[editingDate]))
                    // get deleted data
                    } else if !isAdded && !user[localChagneIsAddOrNot] {
                        data.append(Person(idNumber: user[idNumber], name: user[name], phoneNumber: user[phoneNumber], editingDate: user[editingDate]))
                    }
                }
            }
        } catch {
            print(error)
        }
        return data
    }
    
    func removeAllChangedIdNumber() {
        do {
            try db?.run(Table("local_change_id_table").delete())
        } catch {
            print(error)
        }
    }
    
}
