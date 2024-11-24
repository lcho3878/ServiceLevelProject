//
//  ProfileEditView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/1/24.
//

import UIKit
import SnapKit
import Then

final class ProfileEditView: BaseView {
    private let topDividerView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(resource: .noPhotoB)
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let cameraImageView = CameraImageView()
    
    let camerButton = UIButton()
    
    // 내 새싹 코인 / 닉네임 / 연락처 뷰
    private let firstView = UIStackView().then {
        $0.backgroundColor = .brandWhite
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 8
    }
    
    private let sesacCoinView = UIView()
    private let nicknameView = UIView()
    private let contactView = UIView()
    
    private let sesacCoinTextLabel = UILabel().then {
        $0.text = "내 새싹 코인"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    let coinCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .bodyBold
        $0.textColor = .brand
    }
    private let chargeLabel = UILabel().then {
        $0.text = "충전하기"
        $0.font = .body
        $0.textColor = .darkGray
    }
    private let coinRightButton = UIButton().then {
        $0.setImage(UIImage(resource: .chevronRightLight), for: .normal)
        $0.tintColor = .darkGray
    }
    let chargeButton = UIButton()
    
    private let nicknameTextLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    let nicknameLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .darkGray
    }
    private let nicknameRightButton = UIButton().then {
        $0.setImage(UIImage(resource: .chevronRightLight), for: .normal)
        $0.tintColor = .darkGray
    }
    let nicknameButton = UIButton()
    
    private let contactTextLabel = UILabel().then {
        $0.text = "연락처"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    let contactLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .darkGray
    }
    private let contactRightButton = UIButton().then {
        $0.setImage(UIImage(resource: .chevronRightLight), for: .normal)
        $0.tintColor = .darkGray
    }
    let contactButton = UIButton()
    
    // 이메일 / 연결된 소셜 계정 / 로그아웃 뷰
    private let secondView = UIStackView().then {
        $0.backgroundColor = .brandWhite
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 8
    }
    
    private let emailView = UIView()
    private let linkedSocialAccountsView = UIView()
    private let logoutView = UIView()
    
    private let emailTextLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    let emailLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .darkGray
    }
    
    private let linkedSocialAccountsTextLabel = UILabel().then {
        $0.text = "연결된 소셜 계정"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    private let socialAccountStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }
    let appleView = UIView().then {
        $0.backgroundColor = .brandBlack
        $0.layer.cornerRadius = 10
    }
    private let appleAccountImageView = UIImageView().then {
        $0.image = UIImage(resource: .apple)
    }
    
    let kakaoView = UIView().then {
        $0.backgroundColor = .brandYellow
        $0.layer.cornerRadius = 10
    }
    private let kakaoAccountImageView = UIImageView().then {
        $0.image = UIImage(resource: .kakao)
    }
    
    private let logoutLabel = UILabel().then {
        $0.text = "로그아웃"
        $0.font = .bodyBold
        $0.textColor = .brandBlack
    }
    let logoutButton = UIButton()
    
    override func addSubviews() {
        addSubviews([topDividerView, profileImageView, cameraImageView, camerButton])
        addSubview(firstView)
        firstView.addArrangedSubviews([sesacCoinView, nicknameView, contactView])
        sesacCoinView.addSubviews([sesacCoinTextLabel, coinCountLabel, chargeLabel, coinRightButton, chargeButton])
        nicknameView.addSubviews([nicknameTextLabel, nicknameLabel, nicknameRightButton, nicknameButton])
        contactView.addSubviews([contactTextLabel, contactLabel, contactRightButton, contactButton])
        addSubview(secondView)
        secondView.addArrangedSubviews([emailView, linkedSocialAccountsView, logoutView])
        emailView.addSubviews([emailTextLabel, emailLabel])
        linkedSocialAccountsView.addSubviews([linkedSocialAccountsTextLabel, socialAccountStackView])
        socialAccountStackView.addArrangedSubviews([appleView, kakaoView])
        appleView.addSubview(appleAccountImageView)
        kakaoView.addSubview(kakaoAccountImageView)
        logoutView.addSubviews([logoutLabel, logoutButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(8)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(1)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom).offset(24)
            $0.size.equalTo(70)
            $0.centerX.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(profileImageView).offset(7)
            $0.bottom.equalTo(profileImageView).offset(5)
        }
        
        camerButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.bottom.equalTo(cameraImageView.snp.bottom)
            $0.leading.equalTo(profileImageView.snp.leading)
            $0.trailing.equalTo(cameraImageView.snp.trailing)
        }
        
        // --- firstView ---
        firstView.snp.makeConstraints {
            $0.top.equalTo(cameraImageView.snp.bottom).offset(35)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(132)
        }
        
        // sesacCoinView
        sesacCoinTextLabel.snp.makeConstraints {
            $0.leading.equalTo(sesacCoinView.snp.leading).offset(15)
            $0.centerY.equalTo(sesacCoinView.snp.centerY)
        }
        
        coinCountLabel.snp.makeConstraints {
            $0.leading.equalTo(sesacCoinTextLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(sesacCoinTextLabel.snp.centerY)
        }
        
        chargeLabel.snp.makeConstraints {
            $0.trailing.equalTo(coinRightButton.snp.leading).offset(-10)
            $0.centerY.equalTo(sesacCoinView.snp.centerY)
        }
        
        coinRightButton.snp.makeConstraints {
            $0.trailing.equalTo(sesacCoinView.snp.trailing).offset(-12)
            $0.centerY.equalTo(sesacCoinView.snp.centerY)
            $0.height.equalTo(18)
            $0.width.equalTo(22)
        }
        
        chargeButton.snp.makeConstraints {
            $0.edges.equalTo(sesacCoinView)
        }
        
        // nicknameView
        nicknameTextLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameView.snp.leading).offset(15)
            $0.centerY.equalTo(nicknameView.snp.centerY)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.trailing.equalTo(nicknameRightButton.snp.leading).offset(-10)
            $0.centerY.equalTo(nicknameView.snp.centerY)
        }
        
        nicknameRightButton.snp.makeConstraints {
            $0.trailing.equalTo(nicknameView.snp.trailing).offset(-12)
            $0.centerY.equalTo(nicknameView.snp.centerY)
            $0.height.equalTo(18)
            $0.width.equalTo(22)
        }
        
        nicknameButton.snp.makeConstraints {
            $0.edges.equalTo(nicknameView)
        }
        
        // contactView
        contactTextLabel.snp.makeConstraints {
            $0.leading.equalTo(contactView.snp.leading).offset(15)
            $0.centerY.equalTo(contactView.snp.centerY)
        }
        
        contactLabel.snp.makeConstraints {
            $0.trailing.equalTo(contactRightButton.snp.leading).offset(-10)
            $0.centerY.equalTo(contactView.snp.centerY)
        }
        
        contactRightButton.snp.makeConstraints {
            $0.trailing.equalTo(contactView.snp.trailing).offset(-12)
            $0.centerY.equalTo(contactView.snp.centerY)
            $0.height.equalTo(18)
            $0.width.equalTo(22)
        }
        
        contactButton.snp.makeConstraints {
            $0.edges.equalTo(contactView)
        }
        
        // --- secondView ---
        secondView.snp.makeConstraints {
            $0.top.equalTo(firstView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(132)
        }
        
        // emailView
        emailTextLabel.snp.makeConstraints {
            $0.leading.equalTo(emailView.snp.leading).offset(15)
            $0.centerY.equalTo(emailView.snp.centerY)
        }
        
        emailLabel.snp.makeConstraints {
            $0.trailing.equalTo(emailView.snp.trailing).offset(-12)
            $0.centerY.equalTo(emailView.snp.centerY)
        }
        
        // linkedSocialAccountsView
        linkedSocialAccountsTextLabel.snp.makeConstraints {
            $0.leading.equalTo(linkedSocialAccountsView.snp.leading).offset(15)
            $0.centerY.equalTo(linkedSocialAccountsView.snp.centerY)
        }
        
        socialAccountStackView.snp.makeConstraints {
            $0.trailing.equalTo(linkedSocialAccountsView.snp.trailing).offset(-14)
            $0.centerY.equalTo(linkedSocialAccountsView.snp.centerY)
        }
        
        appleView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        
        kakaoView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        
        appleAccountImageView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(appleView.snp.horizontalEdges).inset(5.5)
            $0.verticalEdges.equalTo(appleView.snp.verticalEdges).inset(4.38)
        }
        
        kakaoAccountImageView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(kakaoView.snp.horizontalEdges).inset(5)
            $0.verticalEdges.equalTo(kakaoView.snp.verticalEdges).inset(5)
        }
        
        // logoutView
        logoutLabel.snp.makeConstraints {
            $0.leading.equalTo(logoutView.snp.leading).offset(15)
            $0.centerY.equalTo(logoutView.snp.centerY)
        }
        
        logoutButton.snp.makeConstraints {
            $0.edges.equalTo(logoutView)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
