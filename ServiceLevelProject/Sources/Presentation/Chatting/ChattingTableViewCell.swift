//
//  ChattingTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit
import SnapKit
import Then

final class ChattingTableViewCell: BaseTableViewCell {
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let tempStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 5
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .caption
        $0.textColor = .textPrimary
    }
    
    private let messageLabel = PaddingLabel().then {
        $0.font = .body
        $0.textColor = .textPrimary
        $0.layer.borderColor = UIColor.viewSeperator.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        $0.numberOfLines = 0
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "08:16 오전"
        $0.font = .caption
        $0.textColor = .textSecondary
    }
    
    private let tempImageStackView = UIView().then {
        $0.backgroundColor = .systemPink
    }
    
    override func addSubviews() {
        tempStackView.addArrangedSubviews([
            messageLabel,
            tempImageStackView
        ])
        addSubviews([
            profileImageView,
            nicknameLabel,
            tempStackView,
            dateLabel,
        ])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safe).offset(6)
            $0.leading.equalTo(safe).offset(16)
            $0.size.equalTo(34)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        tempStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameLabel)
            $0.bottom.equalTo(safe).inset(6)
        }
        
        tempImageStackView.snp.makeConstraints {
            $0.width.equalTo(240)
            $0.height.equalTo(160).priority(.low)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(tempStackView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(safe).inset(30)
            $0.bottom.equalTo(tempStackView)
        }
    }
}

extension ChattingTableViewCell {
    func configureData(_ data: ChattingData) {
        nicknameLabel.text = data.nickname
        profileImageView.image = data.profileImage
        messageLabel.text = data.message
        messageLabel.isHidden = data.message == nil
        tempImageStackView.isHidden = data.images.isEmpty
    }
}
