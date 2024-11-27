//
//  CoinTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class CoinTableViewCell: BaseTableViewCell {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .bodyBold
    }
    
    let amountButton = UIButton().then {
        $0.titleLabel?.font = .title2
        $0.setTitleColor(.brandWhite, for: .normal)
        $0.backgroundColor = .brand
        $0.layer.cornerRadius = 8
    }
    
    override func addSubviews() {
        contentView.addSubviews([titleLabel, amountButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.centerY.equalTo(safeArea)
            $0.leading.equalTo(safeArea).offset(12)
        }
        
        amountButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).inset(12)
            $0.width.equalTo(74)
            $0.height.equalTo(28)
            $0.centerY.equalTo(safeArea)
        }
    }
}

extension CoinTableViewCell {
    func configureCell(element: CoinShopItemListModel) {
        titleLabel.text = "🌱 \(element.item)"
        amountButton.setTitle("￦\(element.amount)", for: .normal)
        selectionStyle = .none
    }
}
