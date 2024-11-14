//
//  WorkspaceInitailView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/14/24.
//

import UIKit
import SnapKit
import Then

final class WorkspaceInitailView: BaseView {
    private let launchCompleteLabel = UILabel().then {
        $0.text = "출시 준비 완료!"
        $0.font = .title1
        $0.textAlignment = .center
        $0.textColor = .brandBlack
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "회원님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!"
        $0.font = .body
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .brandBlack
    }
    
    private let launchCompleteImageView = UIImageView().then {
        $0.image = UIImage(resource: .launching)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    let createWorkspaceButton = BrandColorButton(title: "워크스페이스 생성")
    
    override func addSubviews() {
        addSubviews([launchCompleteLabel, descriptionLabel, launchCompleteImageView, createWorkspaceButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        launchCompleteLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(35)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(launchCompleteLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(25)
        }
        
        launchCompleteImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeArea).inset(12)
            $0.height.equalTo(launchCompleteImageView.snp.width)
        }
        
        createWorkspaceButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.bottom.equalToSuperview().offset(-45)
        }
    }
}

