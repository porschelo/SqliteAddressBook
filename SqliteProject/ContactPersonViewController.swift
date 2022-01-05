//
//  AddContactPersonViewController.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/5.
//

import Foundation
import UIKit
import SQLite

class ContactPersonViewController: UIViewController {
    
    var nameLabel: UILabel!
    var phoneNumberLabel: UILabel!
    var nameTextField: UITextField!
    var phoneNumberTextField: UITextField!
    var confirmButton: UIButton!
    
    var index: Int?
    
    let formGap: CGFloat = 20
    
    init(index: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.index = index
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let returnButton = UIBarButtonItem(
          image: UIImage(systemName: "chevron.backward"),
            style:.plain ,
          target:self ,
          action: #selector(backToPreviousView)
        )
        returnButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = returnButton
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.width , height: 50))
        nameLabel.text = "姓名："
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textColor = .black
        nameLabel.center.x = view.center.x
        
        nameTextField = UITextField(frame: CGRect(x: 0, y: 100 + formGap + nameLabel.frame.height, width: view.frame.width / 1.5, height: 50))
        nameTextField.placeholder = "請輸入姓名"
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.font = UIFont.systemFont(ofSize: 20)
        nameTextField.textColor = .black
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.center.x = view.center.x
        
        phoneNumberLabel = UILabel(frame: CGRect(x: 0, y: nameTextField.frame.origin.y + nameTextField.frame.height + formGap, width: view.frame.width, height: 50))
        phoneNumberLabel.text = "電話："
        phoneNumberLabel.textAlignment = .center
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 25)
        phoneNumberLabel.textColor = .black
        phoneNumberLabel.center.x = view.center.x
        
        phoneNumberTextField = UITextField(frame: CGRect(x: 0, y: phoneNumberLabel.frame.origin.y + phoneNumberLabel.frame.height + formGap, width: view.frame.width / 1.5, height: 50))
        phoneNumberTextField.placeholder = "請輸入電話"
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.borderColor = UIColor.black.cgColor
        phoneNumberTextField.font = UIFont.systemFont(ofSize: 20)
        phoneNumberTextField.textColor = .black
        phoneNumberTextField.clearButtonMode = .whileEditing
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.center.x = view.center.x
        
        confirmButton = UIButton(frame: CGRect(x: 0, y: phoneNumberTextField.frame.origin.y + phoneNumberTextField.frame.height + formGap, width: 100, height: 50))
        confirmButton.setTitle("確認", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.backgroundColor = .black
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.center.x = view.center.x
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        //編輯
        if index != nil {
            nameTextField.text = ViewController.dataSource[index!].name
            phoneNumberTextField.text = ViewController.dataSource[index!].phoneNumber
        }
        
        view.addSubviews(nameLabel, nameTextField, phoneNumberLabel, phoneNumberTextField, confirmButton)
    }
    
    @objc func confirm(_ sender: UIButton) {
        
        let contactPerson = Person(name: nameTextField.text ?? "", phoneNumber: phoneNumberTextField.text ?? "")
        let db = Database(withSqlite: "contact_person.sqlite3")
        
        //編輯
        if index != nil {
            ViewController.dataSource[index!].name = nameTextField.text ?? ""
            ViewController.dataSource[index!].phoneNumber = phoneNumberTextField.text ?? ""
            
            db.updateData(
                idNumber: ViewController.dataSource[index!].idNumber,
                name: nameTextField.text ?? "",
                phoneNumber: phoneNumberTextField.text ?? ""
            )
            //新增
        } else {
            ViewController.dataSource.append(contactPerson)
            
            db.insertData(idNumber: contactPerson.idNumber, name: contactPerson.name, phoneNumber: contactPerson.phoneNumber)
        }
        
        backToPreviousView()
    }
    
    @objc func backToPreviousView() {
        navigationController?.popViewController(animated: true)
    }
    
}
