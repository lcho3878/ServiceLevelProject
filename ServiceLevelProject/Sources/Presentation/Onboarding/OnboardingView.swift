//
//  OnboardingView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class OnboardingView: BaseView {
    
    private let titleLabel = UILabel().then {
        $0.text = "새싹톡을 사용하면 어디서나\n팀을 모을 수 있습니다"
        $0.font = UIFont.title1
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let onboardingImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
    }
    
    let loginButton = BrandColorButton(title: "시작하기")
    
    override func addSubviews() {
        addSubview(titleLabel)
        addSubview(onboardingImageView)
        addSubview(loginButton)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(39)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(60)
        }
        
        onboardingImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(89)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(onboardingImageView.snp.width)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
