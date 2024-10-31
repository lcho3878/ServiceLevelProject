//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class HomeView: BaseView {
    // MARK: UI
    let bgView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let cannotFindTitleLabel = UILabel().then {
        $0.text = "워크스페이스를 찾을 수 없어요."
        $0.font = .title1
        $0.textColor = .brandBlack
        $0.textAlignment = .center
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요."
        $0.font = .body
        $0.textColor = .brandBlack
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let workspaceEmptyImageView = UIImageView().then {
        $0.image = UIImage(resource: .workspaceEmpty)
        $0.contentMode = .scaleAspectFill
    }
    
    let createWorkspaceButton = BrandColorButton(title: "워크스페이스 생성")
    
    // MARK: Functions
    override func addSubviews() {
        addSubview(bgView)
        bgView.addSubviews([cannotFindTitleLabel, guideLabel, workspaceEmptyImageView, createWorkspaceButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        bgView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
        
        cannotFindTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bgView.snp.top).offset(35)
            $0.horizontalEdges.equalTo(bgView).inset(24)
            $0.height.equalTo(30)
        }
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(cannotFindTitleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(bgView.snp.leading).offset(23)
            $0.trailing.equalTo(bgView.snp.trailing).offset(-25)
            $0.height.equalTo(40)
        }
        
        workspaceEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(15)
            $0.leading.equalTo(bgView.snp.leading).offset(10)
            $0.trailing.equalTo(bgView.snp.trailing).offset(-13)
            $0.height.equalTo(workspaceEmptyImageView.snp.width)
        }
        
        createWorkspaceButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-45)
            $0.horizontalEdges.equalTo(bgView.snp.horizontalEdges).inset(24)
            $0.height.equalTo(44)
        }
    }
    
    override func configureUI() {
        backgroundColor = .brandWhite
    }
}
