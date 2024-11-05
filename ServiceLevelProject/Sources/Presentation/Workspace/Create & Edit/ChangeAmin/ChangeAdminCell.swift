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
}

extension ChangeAdminCell {
    func configureCell(element: ChangeAdminTestData) {
        profileImageView.image = UIImage(systemName: element.profileImage)
        userNameLabel.text = element.name
        userEmailLabel.text = element.email
    }
}
