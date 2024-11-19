//
//  AddChannelView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class AddChannelView: BaseView {
    private lazy var channelNameLabel = channelNameLabel(title: "채널 이름")
    lazy var channelNameTextField = channelTextField(placeholder: "채널 이름을 입력하세요 (필수)")
    private lazy var channelDescriptionLabel = channelNameLabel(title: "채널 설명")
    lazy var channelDescriptionTextField = channelTextField(placeholder: "채널을 설명하세요 (옵션)")
    let createButton = BrandColorButton(title: "생성")
    
    override func addSubviews() {
        addSubviews([channelNameLabel, channelNameTextField, channelDescriptionLabel, channelDescriptionTextField, createButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        channelNameLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(24)
        }
        
        channelNameTextField.snp.makeConstraints {
            $0.top.equalTo(channelNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(channelNameLabel)
            $0.height.equalTo(44)
        }
        
        channelDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(channelNameTextField.snp.bottom).offset(24)
            $0.horizontalEdges.height.equalTo(channelNameLabel)
        }
        
        channelDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(channelDescriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(channelDescriptionLabel)
            $0.height.equalTo(channelNameTextField)
        }
        
        createButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.bottom.equalTo(safeArea).inset(24)
            adjustableConstraint = $0.bottom.equalTo(safeArea).inset(24).constraint.layoutConstraints.first
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
        createButton.configuration?.baseBackgroundColor = .brandInactive
    }
}

extension AddChannelView {
    private func channelNameLabel(title: String) -> UILabel {
        return UILabel().then {
            $0.text = title
            $0.font = UIFont.title2
        }
    }
    
    private func channelTextField(placeholder: String) -> UITextField {
        return  UITextField().then {
            $0.placeholder = placeholder
            $0.font = UIFont.title2
            $0.backgroundColor = .brandWhite
            $0.layer.cornerRadius = 8
            $0.horizonPadding(12)
        }
    }
}
