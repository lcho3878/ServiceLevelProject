//
//  ProfileView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class ProfileView: BaseView {
    let profileImageView = UIImageView().then {
        $0.image = UIImage.randomDefaultImage()
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .lightGray
        $0.clipsToBounds = true
    }
    
    private let detailStackView = UIStackView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .brandWhite
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private let nicknameView = UIView()
    private let emailView = UIView()
    private let nicknameTextLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    
    private let emailTextLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    
    let nicknameLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .darkGray
    }
    let emailLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .darkGray
    }
    
    override func addSubviews() {
        addSubviews([profileImageView, detailStackView])
        detailStackView.addArrangedSubviews([nicknameView, emailView])
        nicknameView.addSubviews([nicknameTextLabel, nicknameLabel])
        emailView.addSubviews([emailTextLabel, emailLabel])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(80)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        detailStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(33)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(88)
        }
        
        nicknameTextLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameView.snp.leading).offset(15)
            $0.centerY.equalTo(nicknameView.snp.centerY)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.trailing.equalTo(nicknameView.snp.trailing).offset(-12)
            $0.centerY.equalTo(nicknameView.snp.centerY)
        }
        
        emailTextLabel.snp.makeConstraints {
            $0.leading.equalTo(emailView.snp.leading).offset(15)
            $0.centerY.equalTo(emailView.snp.centerY)
        }
        
        emailLabel.snp.makeConstraints {
            $0.trailing.equalTo(emailView.snp.trailing).offset(-12)
            $0.centerY.equalTo(emailView.snp.centerY)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
