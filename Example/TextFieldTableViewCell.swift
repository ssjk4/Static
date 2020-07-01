//
//  TextFieldTableViewCell.swift
//  Example
//
//  Created by 史小璟 on 2020/7/1.
//  Copyright © 2020 Venmo. All rights reserved.
//

import UIKit
import Static

class TextFieldTableViewCell: UITableViewCell, Cell, UITextFieldDelegate {
    
    @IBOutlet weak private var textField: UITextField!
    
    weak var row: Row?
    
    static func nib() -> UINib? {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    deinit {
        textField.delegate = nil
    }

    func configure(row: Row) {
        self.row = row
        textField.text = row.value as? String ?? ""
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        row?.value = textField.text
    }
}
