//
//  BaseTextField.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/10/24.
//

import UIKit

final class BaseTextField: UITextField {
    init(placeholder: String?, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholder
        font = UIFont.body
        backgroundColor = .brandWhite
        layer.cornerRadius = 8
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        textContentType = .none
        horizonPadding(12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
