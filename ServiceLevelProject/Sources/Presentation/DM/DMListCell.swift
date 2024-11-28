//
//  DMListCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class DMListCell: BaseTableViewCell {
    private let bgView = UIView()
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let detailbgView = UIView()
    
    let userNameLabel = UILabel().then {
        $0.font = .caption
        $0.textColor = .textPrimary
        $0.textAlignment = .left
    }
    let lastChatLabel = UILabel().then {
        $0.font = .caption2
        $0.textColor = .textSecondary
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }
    
    let lastChatDateLabel = UILabel().then {
        $0.font = .caption2
        $0.textColor = .textSecondary
        $0.textAlignment = .right
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
    
    override func addSubviews() {
        addSubview(bgView)
        bgView.addSubview(detailbgView)
        detailbgView.addSubviews([profileImageView, userNameLabel, lastChatLabel, lastChatDateLabel, unreadBadgeView])
        unreadBadgeView.addSubview(unreadCountLabel)
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        bgView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeArea)
            $0.horizontalEdges.equalTo(safeArea).inset(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(bgView).offset(6)
            $0.leading.equalTo(bgView)
            $0.height.width.equalTo(34)
        }
        
        detailbgView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(bgView.snp.trailing).offset(-8)
            $0.verticalEdges.equalTo(bgView.snp.verticalEdges).inset(6)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(detailbgView)
            $0.trailing.equalTo(lastChatDateLabel.snp.leading)
        }
        
        lastChatLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.leading.equalTo(detailbgView)
            $0.trailing.equalTo(unreadBadgeView.snp.leading).offset(-5)
            $0.bottom.equalTo(detailbgView)
        }
        
        lastChatDateLabel.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(5).priority(1)
            $0.trailing.equalTo(detailbgView)
        }
        
        unreadBadgeView.snp.makeConstraints {
            $0.top.equalTo(lastChatDateLabel.snp.bottom)
            $0.leading.equalTo(lastChatLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(detailbgView)
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
    
    func configureCell(element: DMListTestData) {
        profileImageView.image = UIImage(systemName: element.profileImage)
        userNameLabel.text = element.userName
        lastChatLabel.text = element.lastChat
        lastChatDateLabel.text = element.lastChatDate
        
        if element.unreadCount > 0 {
            unreadCountLabel.text = "\(element.unreadCount)"
            unreadBadgeView.isHidden = false
        } else {
            unreadBadgeView.isHidden = true
        }
    }
    
    func configureCell(_ element: DMList) {
        profileImageView.image = UIImage.randomDefaultImage()
        userNameLabel.text = element.nickname
        lastChatLabel.text = element.lastChatting?.content
        if element.unreadCount > 0 {
            unreadCountLabel.text = "\(element.unreadCount)"
            unreadBadgeView.isHidden = false
        } else {
            unreadBadgeView.isHidden = true
        }
    }
}
