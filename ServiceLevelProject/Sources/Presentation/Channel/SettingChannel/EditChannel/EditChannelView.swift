//
//  EditChannelView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/10/24.
//

import UIKit
import SnapKit
import Then

final class EditChannelView: BaseView {
    private let channelNameLabel = UILabel().then {
        $0.text = "채널 이름"
        $0.font = .title2
    }
    private let channelNameTextField = BaseTextField(placeholder: "채널 이름을 입력하세요 (필수)")
    private let channelDescriptionLabel = UILabel().then {
        $0.text = "채널 설명"
        $0.font = .title2
    }
    private let channelDescriptionTextField = BaseTextField(placeholder: "채널을 설명하세요 (옵션)")

    override func addSubviews() {
        addSubviews([
            channelNameLabel, channelNameTextField,
            channelDescriptionLabel, channelDescriptionTextField
        ])
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
            $0.horizontalEdges.equalTo(channelNameLabel)
            $0.height.equalTo(24)
        }
        
        channelDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(channelDescriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(channelNameLabel)
            $0.height.equalTo(44)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
