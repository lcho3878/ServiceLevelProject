//
//  ChangeAdminCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/5/24.
//

import UIKit
import SnapKit
import Then

final class ChangeAdminCell: BaseTableViewCell {
    // MARK: UI
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let userInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    let userNameLabel = UILabel().then {
        $0.font = .bodyBold
        $0.textColor = .textPrimary
        $0.textAlignment = .left
    }
    
    let userEmailLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .textSecondary
        $0.textAlignment = .left
    }
    
    
    // MARK: Functions
    override func addSubviews() {
        contentView.addSubviews([profileImageView, userInfoStackView])
        userInfoStackView.addArrangedSubviews([userNameLabel, userEmailLabel])
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeArea).inset(8)
            $0.leading.equalTo(safeArea).offset(14)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        userInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11)
            $0.verticalEdges.equalTo(safeArea).inset(12)
            $0.trailing.equalTo(safeArea).offset(-74)
        }
    }
    
    override func configureUI() {
        selectionStyle = .none
    }
}

extension ChangeAdminCell {
    
    func configureCell(element: WorkSpaceMember) {
        // 이미지 처리 필요
        userNameLabel.text = element.nickname
        userEmailLabel.text = element.email
        if let profileImage = element.profileImage {
            Task {
                let profileImageData = try await APIManager.shared.loadImage(profileImage)
                profileImageView.image = UIImage(data: profileImageData)
            }
        } else {
            profileImageView.image = UIImage(resource: .noPhotoB)
        }
    }
}
