//
//  TableViewCell.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/4.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var nameLabel: UILabel!
    var phoneNumberLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height / 2))
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textColor = .black
        nameLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nameLabel.textAlignment = .justified
        
        phoneNumberLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2))
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 15)
        phoneNumberLabel.textColor = .black
        phoneNumberLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        phoneNumberLabel.textAlignment = .justified

        self.addSubviews(nameLabel, phoneNumberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
