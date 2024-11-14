//
//  BaseTextField.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/10/24.
//

import UIKit

final class BaseTextField: UITextField {
    init(placeholder: String?, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false, contentType: UITextContentType = .oneTimeCode) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholder
        font = UIFont.title2
        backgroundColor = .brandWhite
        layer.cornerRadius = 8
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        textContentType = contentType
        horizonPadding(12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
