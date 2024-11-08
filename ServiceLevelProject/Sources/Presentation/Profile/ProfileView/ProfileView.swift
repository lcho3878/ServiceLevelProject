//
//  ProfileView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class ProfileView: BaseView {
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .lightGray
        $0.clipsToBounds = true
    }
    
    let profileTableView = UITableView().then {
        $0.rowHeight = 44
        $0.layer.cornerRadius = 8
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.id)
        $0.isScrollEnabled = false
    }
    
    override func addSubviews() {
        addSubviews([
            profileImageView,
            profileTableView
        ])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safe).offset(24)
            $0.horizontalEdges.equalTo(safe).inset(80)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        profileTableView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(33)
            $0.horizontalEdges.equalTo(safe).inset(24)
            $0.height.equalTo(88)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
