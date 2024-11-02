//
//  ProfileEditView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/1/24.
//

import UIKit
import SnapKit
import Then

final class ProfileEditView: BaseView {
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person")
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let cameraImageView = UIImageView().then {
        $0.image = UIImage(systemName: "camera.circle")/*?.withTintColor(.brandWhite, renderingMode: .alwaysOriginal)*/
        $0.tintColor = .brandWhite
        $0.backgroundColor = .brand
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.brandWhite.cgColor
        $0.layer.borderWidth = 2.12
        $0.clipsToBounds = true
    }
    
    let profileMenuTableView = UITableView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 8
        $0.rowHeight = 44
        $0.register(ProfileEditTableViewCell.self, forCellReuseIdentifier: ProfileEditTableViewCell.id)
        $0.isScrollEnabled = false
    }
    
    let profileMenuTableView2 = UITableView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 8
        $0.rowHeight = 44
        $0.register(ProfileEditTableViewCell.self, forCellReuseIdentifier: ProfileEditTableViewCell.id)
        $0.isScrollEnabled = false
    }
    
    override func addSubviews() {
        addSubviews([
            profileImageView, cameraImageView,
            profileMenuTableView, profileMenuTableView2
        ])
    }
    
    override func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.size.equalTo(70)
            $0.centerX.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(profileImageView).offset(7)
            $0.bottom.equalTo(profileImageView).offset(5)
        }
        
        profileMenuTableView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(35)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(132)
        }
        
        profileMenuTableView2.snp.makeConstraints {
            $0.top.equalTo(profileMenuTableView.snp.bottom).offset(35)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(132)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
