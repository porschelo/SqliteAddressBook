//
//  RemoteDatabase.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/6.
//

import Foundation
import OHMySQL

class RemoteDatabase {
    
    var coordinator: OHMySQLStoreCoordinator? = nil
    
//    let dropQueryString: String
//    let dropQueryRequest: OHMySQLQueryRequest
    let context = OHMySQLQueryContext()
    
    init() {
        if let user = OHMySQLUser(userName: "root", password: "0000", serverName: "6.tcp.ngrok.io", dbName: "trainee", port: 18899, socket: nil) {
            coordinator = OHMySQLStoreCoordinator(user: user)
            coordinator?.encoding = .UTF8MB4
            coordinator?.connect()
            
            context.storeCoordinator = coordinator!
        }

//        dropQueryString = "DROP TABLE `table_name2`"
//        dropQueryRequest = OHMySQLQueryRequest(queryString: dropQueryString)
    }
    
    deinit {
        coordinator?.disconnect()
    }
    
    func insertData(idNumber: Int, name: String, phoneNumber: String) {
        do {
            let query = OHMySQLQueryRequestFactory.insert("table_name2", set: ["idNumber": idNumber, "name": name, "phoneNumber": phoneNumber])
            try context.execute(query)
        } catch {
            print(error)
        }
        
    }
    
    func removeData(idNumber: Int) {
        do {
            let query = OHMySQLQueryRequestFactory.delete("table_name2", condition: "idNumber=\(idNumber)")
            try context.execute(query)
        } catch {
            print(error)
        }
    }
    
    func updateData(idNumber: Int, name: String, phoneNumber: String) {
        do {
            let query = OHMySQLQueryRequestFactory.update("table_name2", set: ["idNumber": idNumber, "name": name, "phoneNumber": phoneNumber], condition: "idNumber=\(idNumber)")
            try context.execute(query)
        } catch {
            print(error)
        }
    }
    
    func getData() {
        ViewController.dataSource = []
        
        do {
            let query = OHMySQLQueryRequestFactory.select("table_name2", condition: nil)
            let userDatas = try context.executeQueryRequestAndFetchResult(query)
            for userData in userDatas {
                if let idNumber = userData["idNumber"] as? Int,
                   let name = userData["name"] as? String,
                   let phoneNumber = userData["phoneNumber"] as? String {
                    ViewController.dataSource.append(Person(idNumber: idNumber, name: name, phoneNumber: phoneNumber))
                }
            }
        } catch {
            print(error)
        }
    }
    
    func removeAll() {
        do {
            let query = OHMySQLQueryRequestFactory.delete("table_name2", condition: nil)
            try context.execute(query)
        } catch {
            print(error)
        }
    }
    
}
