//
//  CoinShopView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import SnapKit
import Then

final class CoinShopView: BaseView {
    private let coinView = UIView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "🌱현재 보유한 코인 0개"
        $0.font = .bodyBold
        $0.backgroundColor = .brandWhite
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "코인이란?"
        $0.font = .caption
        $0.textColor = .textSecondary
    }
    
    let coinTableView = UITableView().then {
        $0.rowHeight = 44
        $0.layer.cornerRadius = 8
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.id)
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    override func addSubviews() {
        coinView.addSubviews([titleLabel, subTitleLabel])
        addSubviews([coinView, coinTableView])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        coinView.snp.makeConstraints {
            $0.top.equalTo(safe).offset(24)
            $0.horizontalEdges.equalTo(safe).inset(24)
            $0.height.equalTo(44)
        }
        
        coinTableView.snp.makeConstraints {
            $0.top.equalTo(coinView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(coinView)
            $0.height.equalTo(132)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
