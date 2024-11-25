//
//  SettingCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import UIKit
import SnapKit
import Then

final class SettingCell: BaseTableViewCell {
    let titleLabel = UILabel().then {
        $0.font = .bodyBold
        $0.textColor = .brandBlack
        $0.textAlignment = .left
    }
    
    private let rightButton = UIButton().then {
        $0.setImage(UIImage(resource: .chevronRightLight), for: .normal)
        $0.tintColor = .darkGray
    }
    
    override func addSubviews() {
        contentView.addSubviews([titleLabel, rightButton])
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(15)
            $0.centerY.equalTo(safeArea)
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).offset(-12)
            $0.centerY.equalTo(safeArea)
            $0.height.equalTo(18)
            $0.width.equalTo(22)
        }
    }
    
    override func configureUI() {
        contentView.backgroundColor = .brandWhite
    }
}
