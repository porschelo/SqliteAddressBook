//
//  Extension.swift
//  SqliteProject
//
//  Created by Eric Chang on 2022/1/4.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ view: UIView...) {
        view.forEach {
            addSubview($0)
        }
    }
    
}
