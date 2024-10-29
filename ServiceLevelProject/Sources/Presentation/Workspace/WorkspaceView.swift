//
//  WorkspaceView.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class WorkspaceView: BaseView {
    // MARK: UI
    private let bgView = UIView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 25
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
    }
    
    private let topTitleView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
        $0.layer.cornerRadius = 25
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner)
    }
    
    private let topTitleLabel = UILabel().then {
        $0.text = "워크스페이스"
        $0.font = .title1
    }
    
    let tableView = UITableView().then {
        $0.rowHeight = 72
        $0.separatorColor = .clear
    }
    
    let workspaceEmptyView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let emptyViewElementsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 20
    }
    
    private let cannotFindTitleLabel = UILabel().then {
        $0.text = "워크스페이스를\n찾을 수 없어요."
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .title1
        $0.textColor = .brandBlack
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요."
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .body
        $0.textColor = .brandBlack
    }
    
    let createWorkspaceButton = BrandColorButton(title: "워크스페이스 생성")
    let addWorkspaceButton = BrandSimpeButton(title: "워크스페이스 추가", image: UIImage(resource: .plus))
    let questionButton = BrandSimpeButton(title: "도움말", image: UIImage(resource: .question))

    // MARK: Functions
    override func addSubviews() {
        addSubviews([bgView, topTitleView, tableView, workspaceEmptyView, addWorkspaceButton, questionButton])
        topTitleView.addSubview(topTitleLabel)
        workspaceEmptyView.addSubview(emptyViewElementsStackView)
        emptyViewElementsStackView.addArrangedSubviews([cannotFindTitleLabel, guideLabel, createWorkspaceButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        bgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topTitleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(98)
        }
        
        topTitleLabel.snp.makeConstraints {
            $0.top.equalTo(topTitleView.snp.top).offset(51)
            $0.leading.equalTo(topTitleView.snp.leading).offset(16)
            $0.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topTitleView.snp.bottom)
            $0.horizontalEdges.equalTo(bgView)
            $0.bottom.equalTo(addWorkspaceButton.snp.top)
        }
        
        workspaceEmptyView.snp.makeConstraints {
            $0.top.equalTo(topTitleView.snp.bottom)
            $0.horizontalEdges.equalTo(bgView.snp.horizontalEdges)
            $0.bottom.equalTo(addWorkspaceButton.snp.top)
        }
        
        emptyViewElementsStackView.snp.makeConstraints {
            $0.center.equalTo(workspaceEmptyView.snp.center)
            $0.horizontalEdges.equalTo(workspaceEmptyView.snp.horizontalEdges).inset(16)
        }
        
        createWorkspaceButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(emptyViewElementsStackView.snp.horizontalEdges)
            $0.height.equalTo(44)
        }
        
        addWorkspaceButton.snp.makeConstraints {
            $0.leading.equalTo(safeArea.snp.leading).offset(16)
            $0.bottom.equalTo(questionButton.snp.top)
            $0.height.equalTo(41)
        }
        
        questionButton.snp.makeConstraints {
            $0.leading.equalTo(safeArea.snp.leading).offset(16)
            $0.bottom.equalTo(safeArea)
            $0.height.equalTo(41)
        }
    }
    
    override func configureUI() {
        backgroundColor = .clear
    }
}
