//
//  LoginView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit
import SnapKit
import Then

final class LoginView: BaseView {
    lazy var emailLabel = loginLabel(title: "이메일")
    lazy var emailTextField = BaseTextField(placeholder: "이메일을 입력하세요")
    lazy var passwordLabel = loginLabel(title: "비밀번호")
    lazy var passwordTextField = BaseTextField(placeholder: "비밀번호를 입력하세요", isSecureTextEntry: true)
    let loginButton = BrandColorButton(title: "로그인")
    
    override func addSubviews() {
        addSubviews([
            emailLabel, emailTextField,
            passwordLabel, passwordTextField,
            loginButton
        ])
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
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.horizontalEdges.height.equalTo(emailLabel)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(passwordLabel)
            $0.height.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.bottom.equalTo(safeArea).offset(-24)
            $0.height.equalTo(44)
            adjustableConstraint = $0.bottom.equalTo(safeArea).inset(24).constraint.layoutConstraints.first
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}

extension LoginView {
    private func loginLabel(title: String) -> UILabel {
        return UILabel().then {
            $0.text = title
            $0.font = UIFont.title2
        }
    }
}
