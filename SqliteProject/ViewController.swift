//
//  ViewController.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/4.
//

import UIKit
import SQLite


class ViewController: UIViewController {
            
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        setUpView()
        
        view.addSubview(tableView)
    }
    
    func setUpView() {
        navigationController?.navigationBar.barTintColor = .systemGray6
        
        title = "聯絡人"
        
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style:.plain,
            target:self,
            action: #selector(addContactPerson)
        )
        rightButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = rightButton
        
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func loadData() {
        var remoteIncreasingArray: [Person] = []
        var localIncreasingArray: [Person] = []
        
        if RemoteDatabase.shared.coordinator?.connect() == true {
            RemoteDatabase.isConnectWithRemote = true
            
            Person.dataSource = RemoteDatabase.shared.getData()
            
            let localRemoteDifferenceArray = Person.dataSource.difference(from: LocalDatabase.shared.getData())
            
            for change in localRemoteDifferenceArray {
                switch change {
                // remote 多的資料
                case .insert(offset: _, element: let person, associatedWith: _):
                    remoteIncreasingArray.append(person)
                // local 多的資料
                case .remove(offset: _, element: let person, associatedWith: _):
                    localIncreasingArray.append(person)
                }
            }
            
            // 編輯更新
            for (remoteIndex, remote) in remoteIncreasingArray.enumerated().reversed() {
                for(localIndex, local) in localIncreasingArray.enumerated().reversed() {
                    if remote.idNumber == local.idNumber {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
                        let firstDate = dateFormatter.date(from: remote.editingDate)!
                        let secondDate = dateFormatter.date(from: local.editingDate)!
                        
                        // First Date is smaller then second date
                        if firstDate.compare(secondDate) == .orderedAscending {
                            RemoteDatabase.shared.updateData(idNumber: local.idNumber, name: local.name, phoneNumber: local.phoneNumber, editingDate: local.editingDate)
                        } else {
                            LocalDatabase.shared.updateData(idNumber: remote.idNumber, name: remote.name, phoneNumber: remote.phoneNumber, editingDate: remote.editingDate)
                        }
                        // 刪除原為 remote 與 local 同時編輯的資料
                        localIncreasingArray.remove(at: localIndex)
                        remoteIncreasingArray.remove(at: remoteIndex)
                    }
                }
            }
            
            // 更新 local 新增的資料
            LocalDatabase.shared.getChangedData(isAdded: true).forEach { localAddedPerson in
                RemoteDatabase.shared.insertData(idNumber: localAddedPerson.idNumber, name: localAddedPerson.name, phoneNumber: localAddedPerson.phoneNumber, editingDate: localAddedPerson.editingDate)
                
                // local difference list 刪除原為 local 新增的資料，剩下的差異就是 remote 刪除的資料
                for (index, differenceWithRemotePerson) in localIncreasingArray.enumerated().reversed() {
                    if differenceWithRemotePerson.idNumber == localAddedPerson.idNumber {
                        localIncreasingArray.remove(at: index)
                    }
                }
            }
            
            // 更新 local 刪除的資料
            LocalDatabase.shared.getChangedData(isAdded: false).forEach { localDeletedPerson in
                RemoteDatabase.shared.removeData(idNumber: localDeletedPerson.idNumber)
                
                // remote difference list 刪除原為 local 刪除的資料，剩下的差異就是 remote 新增的資料
                for (index, differenceWithLocalPerson) in remoteIncreasingArray.enumerated().reversed() {
                    if differenceWithLocalPerson.idNumber == localDeletedPerson.idNumber {
                        remoteIncreasingArray.remove(at: index)
                    }
                }
            }
            
            // remote 新增刪除更新
            localIncreasingArray.forEach {
                LocalDatabase.shared.removeData(idNumber: $0.idNumber)
            }
            remoteIncreasingArray.forEach {
                LocalDatabase.shared.insertData(idNumber: $0.idNumber, name: $0.name, phoneNumber: $0.phoneNumber, editingDate: $0.editingDate)
            }
            
            // 刪除 local 暫存的資料
            LocalDatabase.shared.removeAllChangedIdNumber()
            
            Person.dataSource = RemoteDatabase.shared.getData()
        } else {
            Person.dataSource = LocalDatabase.shared.getData()
        }
    }
    
    @objc func addContactPerson(_ sender: UIButton) {
        navigationController?.pushViewController(ContactPersonViewController(), animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Person.dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.nameLabel.text = Person.dataSource[indexPath.row].name
        cell.phoneNumberLabel.text = Person.dataSource[indexPath.row].phoneNumber
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if RemoteDatabase.isConnectWithRemote {
            RemoteDatabase.shared.removeData(idNumber: Person.dataSource[indexPath.row].idNumber)
        } else {
            // Record deleted id number which should be removed in RemoteDatabase
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
            let nowString = formatter.string(from: Date())
            
            LocalDatabase.shared.insertChangedIdData(
                idNumber: Person.dataSource[indexPath.row].idNumber,
                name: Person.dataSource[indexPath.row].name,
                phoneNumber: Person.dataSource[indexPath.row].phoneNumber,
                editingDate: nowString,
                localChagneIsAddOrNot: false
            )
        }
        
        LocalDatabase.shared.removeData(idNumber: Person.dataSource[indexPath.row].idNumber)
        
        Person.dataSource.remove(at: indexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ContactPersonViewController(index: indexPath.row), animated: true)
    }
    
}
