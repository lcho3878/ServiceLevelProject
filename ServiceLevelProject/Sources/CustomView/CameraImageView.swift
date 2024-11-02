//
//  CameraImageView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit

final class CameraImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        image = UIImage(systemName: "camera.circle")
        tintColor = .brandWhite
        backgroundColor = .brand
        layer.cornerRadius = 12
        layer.borderColor = UIColor.brandWhite.cgColor
        layer.borderWidth = 2.12
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
