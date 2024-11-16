//
//  BrandColorButton.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/28/24.
//

import UIKit

final class BrandColorButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .brand : .brandInactive
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .title2
        setTitleColor(.brandWhite, for: .normal)
        backgroundColor = .brand
        layer.cornerRadius = 8
    }
    
    init(title: String, image: UIImage?) {
        super.init(frame: CGRect.zero)
        
        var configuration = UIButton.Configuration.bordered()
        var attributedString = AttributedString(stringLiteral: title)
        attributedString.font = UIFont.title2
        configuration.attributedTitle = attributedString
        configuration.baseForegroundColor = .brandWhite
        configuration.image = image
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .brand
        configuration.background.cornerRadius = 8
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
