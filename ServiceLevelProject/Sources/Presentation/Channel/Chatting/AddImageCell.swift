//
//  AddImageCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class AddImageCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    let imageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let xButtonView = UIView()
    private let xButton = UIButton().then {
        $0.setImage(UIImage(resource: .xButton), for: .normal)
        $0.tintColor = .brandBlack
    }
    
    let deleteButton = UIButton()
    
    override func addSubviews() {
        contentView.addSubviews([imageView, xButtonView, xButton, deleteButton])
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        imageView.snp.makeConstraints {
            $0.leading.bottom.equalTo(safeArea)
            $0.width.height.equalTo(44)
        }
        
        xButtonView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top).offset(-6)
            $0.trailing.equalTo(imageView.snp.trailing).offset(6)
            $0.height.width.equalTo(20)
        }
        
        xButton.snp.makeConstraints {
            $0.edges.equalTo(xButtonView).inset(2)
        }
        
        deleteButton.snp.makeConstraints {
            $0.edges.equalTo(xButtonView)
        }
    }
}
