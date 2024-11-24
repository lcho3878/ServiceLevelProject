//
//  PhoneNumberEditView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit

final class PhoneNumberEditView: BaseView {
    var isTextFieldEmpty: Bool = false {
        didSet {
            confirmButton.isEnabled = !isTextFieldEmpty
            confirmButton.configuration?.baseBackgroundColor = isTextFieldEmpty ? .brandInactive : .brand
        }
    }
    
    let phoneNumberTextField = UITextField().then {
        $0.placeholder = "전화번호를 입력하세요"
        $0.backgroundColor = .brandWhite
        $0.font = UIFont.body
        $0.layer.cornerRadius = 8
        $0.keyboardType = .numberPad
        $0.horizonPadding(12)
    }
    
    let confirmButton = BrandColorButton(title: "완료")

    override func addSubviews() {
        addSubviews([phoneNumberTextField, confirmButton])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        phoneNumberTextField.snp.makeConstraints {
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
