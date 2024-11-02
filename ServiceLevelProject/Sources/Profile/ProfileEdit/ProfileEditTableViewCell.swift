//
//  ProfileEditTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/1/24.
//

import UIKit
import SnapKit
import Then

final class ProfileEditTableViewCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = UIFont.bodyBold
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.body
        $0.textColor = .textSecondary
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .textSecondary
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

extension ProfileEditTableViewCell {
    private func addSubview() {
        addSubviews([
            titleLabel, subTitleLabel,
            chevronImageView
        ])
    }
    
    private func setConstraints() {
        let safe = safeAreaLayoutGuide
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(safe).offset(15)
            $0.height.equalTo(18)
            $0.top.equalTo(safe).offset(13)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalTo(safe).inset(12)
            $0.width.equalTo(22.33)
            $0.height.equalTo(20)
            $0.centerY.equalTo(titleLabel)
        }

        subTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(chevronImageView)
            $0.height.equalTo(chevronImageView)
            $0.size.equalTo(subTitleLabel)
            $0.trailing.equalTo(chevronImageView.snp.leading).inset(-10)
        }
    }
    
    func configureData(_ data: TableViewRepresentable) {
        titleLabel.text = data.titleString
        subTitleLabel.text = data.subTitleString
    }
}

protocol TableViewRepresentable {
    var titleString: String { get }
    var subTitleString: String { get }
}
