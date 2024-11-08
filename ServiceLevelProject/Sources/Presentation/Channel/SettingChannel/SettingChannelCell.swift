//
//  SettingChannelCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class SettingChannelCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView().then {
        $0.image = UIImage.profile
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "Hue"
        $0.textAlignment = .center
        $0.font = .body
    }
    
    override func addSubviews() {
        addSubviews([profileImageView, nameLabel])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(safe).offset(16.07)
            $0.centerX.equalTo(safe)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(safe)
        }
    }
}
