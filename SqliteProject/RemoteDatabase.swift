//
//  RemoteDatabase.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/6.
//

import Foundation
import OHMySQL

class RemoteDatabase {
    
    static var shared: RemoteDatabase = {
        let db = RemoteDatabase(userName: "root", password: "0000", serverName: "6.tcp.ngrok.io", dbName: "trainee", port: 17082,tableName: "user_information_table")
        
        return db
    }()
    
    static var isConnectWithRemote: Bool = false
    
    var coordinator: OHMySQLStoreCoordinator? = nil
    
    let context = OHMySQLQueryContext()
    
    var tableName: String = ""
    
    init(userName: String, password: String, serverName: String, dbName: String, port: Int, socket: String? = nil, tableName: String) {
        
        self.tableName = tableName
        
        if let user = OHMySQLUser(userName: userName, password: password, serverName: serverName, dbName: dbName, port: 17082, socket: nil) {
            coordinator = OHMySQLStoreCoordinator(user: user)
            coordinator?.encoding = .UTF8MB4
            coordinator?.connect()
            
            context.storeCoordinator = coordinator!
            
            createTable(tableName: tableName)
        }
    }
    
    deinit {
        coordinator?.disconnect()
    }
    
    func insertData(idNumber: Int, name: String, phoneNumber: String, editingDate: String) {
        do {
            let query = OHMySQLQueryRequestFactory.insert(tableName, set: ["idNumber": idNumber, "name": name, "phoneNumber": phoneNumber, "editingDate": editingDate])
            try context.execute(query)
        } catch {
            print(error)
        }
    }
    
    func removeData(idNumber: Int) {
        do {
            let query = OHMySQLQueryRequestFactory.delete(tableName, condition: "idNumber=\(idNumber)")
            try context.execute(query)
        } catch {
            print(error)
        }
    }
    
    func updateData(idNumber: Int, name: String, phoneNumber: String, editingDate: String) {
        do {
            let query = OHMySQLQueryRequestFactory.update(tableName, set: ["idNumber": idNumber, "name": name, "phoneNumber": phoneNumber, "editingDate": editingDate], condition: "idNumber=\(idNumber)")
            try context.execute(query)
        } catch {
            print(error)
        }
    }
    
    func getData() -> [Person] {
        var data: [Person] = []
        
        do {
            let query = OHMySQLQueryRequestFactory.select(tableName, condition: nil)
            let userDatas = try context.executeQueryRequestAndFetchResult(query)
            for userData in userDatas {
                if let idNumber = userData["idNumber"] as? Int,
                   let name = userData["name"] as? String,
                   let phoneNumber = userData["phoneNumber"] as? String,
                   let editingDate = userData["editingDate"] as? String {
                    data.append(Person(idNumber: idNumber, name: name, phoneNumber: phoneNumber, editingDate: editingDate))
                }
            }
        } catch {
            print(error)
        }
        
        return data
    }
    
    func removeAll() {
        do {
            let query = OHMySQLQueryRequestFactory.delete(tableName, condition: nil)
            try context.execute(query)
        } catch {
            print(error)
        }
    }
    
    func createTable(tableName: String) {
        let createQueryString = "CREATE TABLE `\(tableName)` (`idNumber` int, `name` varchar(10), `phoneNumber` varchar(10), `editingDate` varchar(30))"
        let createQueryRequest = OHMySQLQueryRequest(queryString: createQueryString)
        do {
            try context.execute(createQueryRequest)
        } catch {
            print(error)
        }
    }
    
    func removeTable(tableName: String) {
        let dropQueryString = "DROP TABLE `\(tableName)`"
        let dropQueryRequest = OHMySQLQueryRequest(queryString: dropQueryString)
        do {
            try context.execute(dropQueryRequest)
        } catch {
            print(error)
        }
    }
    
}
