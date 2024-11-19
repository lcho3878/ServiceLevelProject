//
//  SearchChannelCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class SearchChannelCell: BaseTableViewCell {
    private let hashTagImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .hashTagBold)
        $0.tintColor = .textPrimary
    }
    
    let channelNameLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.font = .bodyBold
        $0.textAlignment = .left
    }
    
    override func addSubviews() {
        contentView.addSubviews([hashTagImageView, channelNameLabel])
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        hashTagImageView.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(17.8)
            $0.centerY.equalTo(safeArea.snp.centerY)
            $0.width.height.equalTo(14.4)
        }
        
        channelNameLabel.snp.makeConstraints {
            $0.leading.equalTo(hashTagImageView.snp.trailing).offset(17.8)
            $0.verticalEdges.equalTo(safeArea).inset(6.5)
            $0.trailing.equalTo(safeArea).offset(-10)
        }
    }
    
    func configureCell(element: ChannelListModel) {
        channelNameLabel.text = element.name
    }
}
