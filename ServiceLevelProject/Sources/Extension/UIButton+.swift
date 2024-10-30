//
//  UIButton+.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/30/24.
//

import UIKit

extension UIButton {
    func topProfileUI(imageName: String) {
        setImage(UIImage(systemName: imageName), for: .normal)
        layer.borderColor = UIColor.brandBlack.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    func topCoverImageUI(imageName: String) {
        setImage(UIImage(systemName: imageName), for: .normal)
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = .brandWhite
    }
}
