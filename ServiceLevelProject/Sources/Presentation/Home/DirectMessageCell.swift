//
//  DirectMessageCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/6/24.
//

import UIKit
import SnapKit
import Then

final class DirectMessageCell: BaseTableViewCell {
    // MARK: UI
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
    }
    let userNameLabel = UILabel().then {
        $0.textColor = .textSecondary
        $0.font = .body
        $0.textAlignment = .left
    }
    
    // MARK: Functions
    override func addSubviews() {
        contentView.addSubviews([profileImageView, userNameLabel])
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(14)
            $0.centerY.equalTo(safeArea)
            $0.width.height.equalTo(24)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11)
            $0.verticalEdges.equalTo(safeArea).inset(13)
            $0.trailing.equalTo(safeArea).offset(-43)
        }
        
        // 숫자 넣기
    }
    
    func configureCell(element: DirectMessageTestData) {
        profileImageView.image = UIImage(systemName: element.chatProfileImage)
        userNameLabel.text = element.chatFriendName
        selectionStyle = .none
    }
}
