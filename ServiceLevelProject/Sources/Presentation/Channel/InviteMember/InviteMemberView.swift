//
//  InviteMemberView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class InviteMemberView: BaseView {
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = .title2
        $0.textColor = .brandBlack
    }
    
    let emailTextField = UITextField().then {
        $0.placeholder = "초대하려는 팀원의 이메일을 입력하세요."
        $0.font = UIFont.title2
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 8
        $0.horizonPadding(12)
    }
    
    private let inviteButton = BrandColorButton(title: "초대 보내기")
    
    override func addSubviews() {
        addSubviews([emailLabel, emailTextField, inviteButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(24)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(emailLabel)
            $0.height.equalTo(44)
        }
        
        inviteButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.bottom.equalTo(safeArea).inset(24)
            adjustableConstraint = $0.bottom.equalTo(safeArea).inset(24).constraint.layoutConstraints.first
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
