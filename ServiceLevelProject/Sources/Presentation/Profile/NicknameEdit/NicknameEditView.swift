//
//  NicknameEditView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class NicknameEditView: BaseView {
    private let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력하세요"
        $0.backgroundColor = .brandWhite
        $0.font = UIFont.body
        $0.layer.cornerRadius = 8
        $0.horizonPadding(12)
    }
    
    private let confirmButton = BrandColorButton(title: "완료")

    override func addSubviews() {
        addSubviews([nicknameTextField, confirmButton])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(safe).offset(24)
            $0.horizontalEdges.equalTo(safe).inset(24)
            $0.height.equalTo(44)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.equalTo(safe).inset(24)
            adjustableConstraint = $0.bottom.equalTo(safe).inset(24).constraint.layoutConstraints.first
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
