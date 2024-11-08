//
//  SearchChannelView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class SearchChannelView: BaseView {
    private let topDividerView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    let tableView = UITableView().then {
        $0.register(SearchChannelCell.self, forCellReuseIdentifier: SearchChannelCell.id)
        $0.rowHeight = 41
        $0.separatorStyle = .none
    }
    
    override func addSubviews() {
        addSubviews([topDividerView, tableView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(8)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundSecondary
    }
}
