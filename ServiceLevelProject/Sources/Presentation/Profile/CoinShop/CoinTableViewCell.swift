//
//  CoinTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class CoinTableViewCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = .bodyBold
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .title2
        $0.textAlignment = .center
        $0.textColor = .brandWhite
        $0.backgroundColor = .brand
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CoinTableViewCell {
    private func addSubview() {
        addSubviews([titleLabel, subTitleLabel])
    }
    
    private func setConstraints() {
        let safe = safeAreaLayoutGuide
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.centerY.equalTo(safe)
            $0.leading.equalTo(safe).offset(12)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.trailing.equalTo(safe).inset(12)
            $0.width.equalTo(74)
            $0.height.equalTo(28)
            $0.centerY.equalTo(safe)
        }
        
    }
    
    func configureData(_ data: TableViewRepresentable) {
        titleLabel.text = data.titleString
        subTitleLabel.text = data.subTitleString
    }
}
