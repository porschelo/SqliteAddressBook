//
//  ViewController.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/4.
//

import UIKit
import SQLite


class ViewController: UIViewController {
    
    var db = Database(withSqlite: "contact_person.sqlite3")
    
    var remoteDB = RemoteDatabase()
    
    static var dataSource: [Person] = []
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .systemGray6
        
        title = "聯絡人"
        
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style:.plain,
            target:self,
            action: #selector(addContactPerson))
        rightButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = rightButton
        
        loadData()
        
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func loadData() {
        remoteDB.getData()
    }
    
    @objc func addContactPerson(_ sender: UIButton) {
        navigationController?.pushViewController(ContactPersonViewController(), animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.nameLabel.text = ViewController.dataSource[indexPath.row].name
        cell.phoneNumberLabel.text = ViewController.dataSource[indexPath.row].phoneNumber
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        remoteDB.removeData(idNumber: ViewController.dataSource[indexPath.row].idNumber)
        
        ViewController.dataSource.remove(at: indexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ContactPersonViewController(index: indexPath.row), animated: true)
    }
    
}
