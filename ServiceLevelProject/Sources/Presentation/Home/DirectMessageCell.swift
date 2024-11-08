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
    
    let unreadBadgeView = UIView().then {
        $0.backgroundColor = .brand
        $0.layer.cornerRadius = 8
    }
    
    let unreadCountLabel = UILabel().then {
        $0.font = .caption
        $0.textColor = .brandWhite
        $0.textAlignment = .center
    }
    
    // MARK: Functions
    override func addSubviews() {
        contentView.addSubviews([profileImageView, userNameLabel, unreadBadgeView])
        unreadBadgeView.addSubview(unreadCountLabel)
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
            $0.trailing.equalTo(unreadBadgeView.snp.leading).offset(-10)
        }
        
        unreadBadgeView.snp.makeConstraints {
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-16)
            $0.centerY.equalTo(safeArea.snp.centerY)
            $0.verticalEdges.equalTo(unreadCountLabel.snp.verticalEdges).inset(-2)
            $0.horizontalEdges.equalTo(unreadCountLabel.snp.horizontalEdges).inset(-4)
        }
        
        unreadCountLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(unreadBadgeView.snp.verticalEdges).inset(2)
            $0.horizontalEdges.equalTo(unreadBadgeView.snp.horizontalEdges).inset(4)
            $0.width.greaterThanOrEqualTo(11).priority(1)
            $0.height.equalTo(14)
        }
    }
    
    func configureCell(element: DirectMessageTestData) {
        profileImageView.image = UIImage(systemName: element.chatProfileImage)
        userNameLabel.text = element.chatFriendName
        if element.unreadCount > 0 {
            unreadCountLabel.text = "\(element.unreadCount)"
        } else {
            unreadBadgeView.isHidden = true
        }
        selectionStyle = .none
    }
}
