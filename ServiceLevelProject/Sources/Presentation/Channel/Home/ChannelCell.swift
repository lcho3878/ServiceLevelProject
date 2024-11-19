//
//  ChannelCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/5/24.
//

import UIKit
import SnapKit
import Then

final class ChannelCell: BaseTableViewCell {
    private let hasTagImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .hashTag)
        $0.tintColor = .textSecondary
    }
    
    let channelNameLabel = UILabel().then {
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
    
    override func addSubviews() {
        contentView.addSubviews([hasTagImageView, channelNameLabel, unreadBadgeView])
        unreadBadgeView.addSubview(unreadCountLabel)
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        hasTagImageView.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(17.8)
            $0.centerY.equalTo(safeArea.snp.centerY)
            $0.width.height.equalTo(14.4)
        }
        
        channelNameLabel.snp.makeConstraints {
            $0.leading.equalTo(hasTagImageView.snp.trailing).offset(17.8)
            $0.verticalEdges.equalTo(safeArea).inset(6.5)
            $0.trailing.equalTo(unreadBadgeView.snp.leading).offset(-10)
        }
        
        unreadBadgeView.snp.makeConstraints {
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-17)
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
    
    func configureCell(element: ChannelList) {
        channelNameLabel.text = element.name
        if element.unreadCount > 0 {
            unreadCountLabel.text = "\(element.unreadCount)"
        } else {
            unreadBadgeView.isHidden = true
        }
        selectionStyle = .none
    }
}
