//
//  ProfileTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class ProfileTableViewCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = UIFont.bodyBold
    }
    
    let contentLabel = UILabel().then {
        $0.font = UIFont.body
        $0.textColor = .textSecondary
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileTableViewCell {
    private func addSubview() {
        addSubviews([
            titleLabel, contentLabel,
        ])
    }
    
    private func setConstraints() {
        let safe = safeAreaLayoutGuide
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(safe).offset(15)
            $0.height.equalTo(18)
            $0.top.equalTo(safe).offset(13)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(safe).offset(13)
            $0.height.equalTo(18)
            $0.trailing.equalTo(safe).inset(12)
        }
    }
}
