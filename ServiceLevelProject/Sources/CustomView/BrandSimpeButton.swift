//
//  BrandSimpeButton.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit

final class BrandSimpeButton: UIButton {
    
    init(title: String, image: UIImage) {
        super.init(frame: CGRect.zero)
        
        var configuration = UIButton.Configuration.plain()
        var attributedString = AttributedString(stringLiteral: title)
        attributedString.font = UIFont.body
        configuration.attributedTitle = attributedString
        configuration.baseForegroundColor = .textPrimary
        configuration.image = image
        configuration.imagePadding = 16
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
