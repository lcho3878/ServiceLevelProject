//
//  BaseView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/27/24.
//

import UIKit

class BaseView: UIView, ViewRepresentable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
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
