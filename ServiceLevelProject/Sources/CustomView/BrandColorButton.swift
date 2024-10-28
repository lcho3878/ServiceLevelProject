//
//  BrandColorButton.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/28/24.
//

import UIKit

final class BrandColorButton: UIButton {
    
    init(title: String, image: UIImage? = nil) {
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
