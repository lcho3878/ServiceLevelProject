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
    
    override func addSubviews() {
        contentView.addSubviews([hasTagImageView, channelNameLabel])
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
            $0.trailing.equalTo(safeArea).offset(-45)
        }
        
        // 숫자 넣기
    }
    
    func configureCell(element: ChannelTestData) {
        channelNameLabel.text = element.channelName
        selectionStyle = .none
    }
}
