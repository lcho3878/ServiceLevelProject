//
//  BaseTextField.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/10/24.
//

import UIKit

final class BaseTextField: UITextField {
    init(placeholder: String?) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholder
        font = UIFont.title2
        backgroundColor = .brandWhite
        layer.cornerRadius = 8
        horizonPadding(12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
