//
//  DMView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class DMView: BaseView {
    private let topDividerView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.register(DMMemberCell.self, forCellWithReuseIdentifier: DMMemberCell.id)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let memberListDivererView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    let tableView = UITableView().then {
        $0.register(DMListCell.self, forCellReuseIdentifier: DMListCell.id)
        $0.rowHeight = 66
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    override func addSubviews() {
        addSubviews([topDividerView, collectionView, memberListDivererView, tableView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(8)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(100)
        }
        
        memberListDivererView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(memberListDivererView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundSecondary
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 76, height: 98.14)
        layout.scrollDirection = .horizontal
        return layout
    }
}
