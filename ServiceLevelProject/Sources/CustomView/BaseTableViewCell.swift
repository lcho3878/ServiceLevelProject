//
//  BaseTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
