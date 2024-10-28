//
//  AuthorizationView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/28/24.
//

import UIKit
import SnapKit

final class AuthorizationView: BaseView {
    
    let appleButton = BrandColorButton(title: "Apple로 계속하기", image: UIImage.apple).then {
        $0.configuration?.baseBackgroundColor = .brandBlack
    }
    let kakaoButton = BrandColorButton(title: "카카오로 계속하기", image: UIImage.kakao).then {
        $0.configuration?.baseForegroundColor = .brandBlack
        $0.configuration?.baseBackgroundColor = .brandYellow
    }
    let emailButton = BrandColorButton(title: "이메일로 계속하기", image: UIImage.email)
    lazy var signupButton = attributedButton()
    
    override func addSubviews() {
        addSubviews([appleButton, kakaoButton, emailButton, signupButton])
    }
    
    override func setConstraints() {
        appleButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(35)
            $0.height.equalTo(44)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.top.equalTo(appleButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(appleButton)
            $0.height.equalTo(appleButton)
        }
        
        emailButton.snp.makeConstraints {
            $0.top.equalTo(kakaoButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(appleButton)
            $0.height.equalTo(appleButton)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(emailButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(appleButton)
            $0.height.equalTo(20)
        }
    }
}

extension AuthorizationView {
    private func attributedButton() -> UIButton {
        let button = UIButton()
            var configuration = UIButton.Configuration.plain()
            let fullString = "또는 새롭게 회원가입 하기"
            let highlightedText = "새롭게 회원가입 하기"
            let attributedString = NSMutableAttributedString(
                string: fullString,
                attributes: [
                    .foregroundColor: UIColor.brandBlack,
                    .font: UIFont.title2
                ]
            )

            if let range = fullString.range(of: highlightedText) {
                let nsRange = NSRange(range, in: fullString)
                attributedString.addAttribute(.foregroundColor, value: UIColor.brand, range: nsRange)
            }
            configuration.attributedTitle = AttributedString(attributedString)
        button.configuration = configuration
        
        return button
    }
}
