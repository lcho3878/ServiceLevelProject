//
//  BaseCollectionViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {}
    func setConstraints() {}
    func configureUI() {}
}
