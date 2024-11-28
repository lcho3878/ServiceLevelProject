//
//  WorkspaceSettingView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class WorkspaceSettingView: BaseView {
    // MARK: UI
    let workspaceImageView = UIImageView().then {
        $0.image = UIImage(resource: .defaultProfile)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .brand
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let cameraImageView = CameraImageView()
    
    let editImageButton = UIButton()
    
    private let workspaceNameLabel = UILabel().then {
        $0.text = "워크스페이스 이름"
        $0.font = .title2
        $0.textColor = .brandBlack
        $0.textAlignment = .left
    }
    
    let workspaceNameTextField = UITextField().then {
        $0.placeholder = "워크스페이스 이름을 입력하세요 (필수)"
        $0.backgroundColor = .backgroundSecondary
        $0.font = UIFont.body
        $0.layer.cornerRadius = 8
        $0.horizonPadding(12)
    }
    
    private let workspaceDescriptionLabel = UILabel().then {
        $0.text = "워크스페이스 설명"
        $0.font = .title2
        $0.textColor = .brandBlack
        $0.textAlignment = .left
    }
    
    let workspaceDescriptionTextField = UITextField().then {
        $0.placeholder = "워크스페이스를 설명하세요 (옵션)"
        $0.backgroundColor = .backgroundSecondary
        $0.font = UIFont.body
        $0.layer.cornerRadius = 8
        $0.horizonPadding(12)
    }
    
    let createWorkspaceButton = BrandColorButton(title: "")
    
    // MARK: Functions
    override func addSubviews() {
        addSubviews([workspaceImageView, cameraImageView, editImageButton, workspaceNameLabel, workspaceNameTextField, workspaceDescriptionLabel, workspaceDescriptionTextField, createWorkspaceButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        workspaceImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(24)
            $0.centerX.equalTo(safeArea)
            $0.height.width.equalTo(70)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.trailing.equalTo(workspaceImageView).offset(7)
            $0.bottom.equalTo(workspaceImageView).offset(5)
            $0.height.width.equalTo(24)
        }
        
        editImageButton.snp.makeConstraints {
            $0.edges.equalTo(workspaceImageView)
        }
        
        workspaceNameLabel.snp.makeConstraints {
            $0.top.equalTo(workspaceImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(24)
        }
        
        workspaceNameTextField.snp.makeConstraints {
            $0.top.equalTo(workspaceNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(44)
        }
        
        workspaceDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(workspaceNameTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(24)
        }
        
        workspaceDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(workspaceDescriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(44)
        }
        
        createWorkspaceButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.bottom.equalTo(safeArea).offset(-24)
            $0.height.equalTo(44)
            adjustableConstraint = $0.bottom.equalTo(safeArea).inset(24).constraint.layoutConstraints.first
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
    
    func configureButtonTitle(title: String) {
        createWorkspaceButton.setTitle(title, for: .normal)
    }
}
