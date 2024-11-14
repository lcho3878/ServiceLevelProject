//
//  SignupView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit
import SnapKit
import Then

final class SignupView: BaseView {
    lazy var emailLabel = signupLabel(title: "이메일")
    lazy var emailTextField = BaseTextField(placeholder: "이메일을 입력하세요")
    let emailValidationButton = BrandColorButton(title: "중복 확인")
    lazy var nicknameLabel = signupLabel(title: "닉네임")
    lazy var nicknameTextField = BaseTextField(placeholder: "닉네임을 입력하세요")
    lazy var contactLabel = signupLabel(title: "연락처")
    lazy var contactTextField = BaseTextField(placeholder: "전화번호를 입력하세요", keyboardType: .numberPad).then {
        $0.delegate = self
    }
    lazy var passwordLabel = signupLabel(title: "비밀번호")
    lazy var passwordTextField = BaseTextField(placeholder: "비밀번호를 입력하세요", isSecureTextEntry: true)
    lazy var passwordCheckLabel = signupLabel(title: "비밀번호 확인")
    lazy var passwordCheckTextField = BaseTextField(placeholder: "비밀번호를 한 번 더 입력하세요", isSecureTextEntry: true)
    let signupButton = BrandColorButton(title: "가입하기")
    
    
    override func addSubviews() {
        addSubviews([
            emailLabel, emailTextField, emailValidationButton,
            nicknameLabel, nicknameTextField,
            contactLabel, contactTextField,
            passwordLabel, passwordTextField,
            passwordCheckLabel, passwordCheckTextField,
            signupButton
        ])
    }
    
    override func setConstraints() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(24)
        }
        
        emailValidationButton.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(emailLabel)
            $0.width.equalTo(100)
            $0.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailValidationButton)
            $0.leading.equalTo(emailLabel)
            $0.trailing.equalTo(emailValidationButton.snp.leading).offset(-12)
            $0.height.equalTo(emailValidationButton)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(emailValidationButton.snp.bottom).offset(24)
            $0.horizontalEdges.height.equalTo(emailLabel)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(emailLabel)
            $0.height.equalTo(emailTextField)
        }
        
        contactLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(24)
            $0.horizontalEdges.height.equalTo(emailLabel)
        }
        
        contactTextField.snp.makeConstraints {
            $0.top.equalTo(contactLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(emailLabel)
            $0.height.equalTo(emailTextField)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(contactTextField.snp.bottom).offset(24)
            $0.horizontalEdges.height.equalTo(emailLabel)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(emailLabel)
            $0.height.equalTo(emailTextField)
        }
        
        passwordCheckLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
            $0.horizontalEdges.height.equalTo(emailLabel)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheckLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(emailLabel)
            $0.height.equalTo(emailTextField)
        }
        
        signupButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(24)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundColor = .backgroundPrimary
        signupButton.configuration?.baseBackgroundColor = .brandInactive
        signupButton.isEnabled = false
        emailValidationButton.configuration?.baseBackgroundColor = .brandInactive
        emailValidationButton.isEnabled = false
    }
}

extension SignupView {
    private func signupLabel(title: String) -> UILabel {
        return UILabel().then {
            $0.text = title
            $0.font = UIFont.title2
        }
    }
}

extension SignupView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        let digits = newText.filter { $0.isNumber }
        
        if string.isEmpty {
            if digits.count == 7 || digits.count == 6 {
                textField.text = digits
            } else {
                textField.text = formattedNumber(digits)
            }
        } else {
            textField.text = formattedNumber(digits)
        }
        
        return false
    }
    
    private func formattedNumber(_ digits: String) -> String {
        var formattedText = ""
        
         if digits.count <= 3 {
             formattedText = digits
         } else if digits.count <= 5 {
             formattedText = "\(digits.prefix(3))-\(digits.suffix(from: digits.index(digits.startIndex, offsetBy: 3)))"
         } else if digits.count <= 8 {
             let prefix = digits.prefix(3)
             let middle = digits[digits.index(digits.startIndex, offsetBy: 3)..<digits.index(digits.startIndex, offsetBy: min(7, digits.count))]
             formattedText = "\(prefix)-\(middle)-\(digits.suffix(from: digits.index(digits.startIndex, offsetBy: min(7, digits.count))))"
         } else if digits.count <= 10 {
             let prefix = digits.prefix(3)
             let middle = digits[digits.index(digits.startIndex, offsetBy: 3)..<digits.index(digits.startIndex, offsetBy: 6)]
             let suffix = digits.suffix(from: digits.index(digits.startIndex, offsetBy: 6))
             formattedText = "\(prefix)-\(middle)-\(suffix)"
         } else {
             let prefix = digits.prefix(3)
             let middle = digits[digits.index(digits.startIndex, offsetBy: 3)..<digits.index(digits.startIndex, offsetBy: 7)]
             let suffix = digits.suffix(from: digits.index(digits.startIndex, offsetBy: 7))
             formattedText = "\(prefix)-\(middle)-\(suffix)"
         }

         return formattedText
    }
}
