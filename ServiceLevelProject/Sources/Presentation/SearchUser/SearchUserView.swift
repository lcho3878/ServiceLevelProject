//
//  SearchUserView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import UIKit
import SnapKit
import Then

final class SearchUserView: BaseView {
    let searchBar = UISearchBar().then {
        $0.placeholder = "멤버 이름을 검색해주세요."
        $0.showsCancelButton = true
    }
    let tableView = UITableView().then {
        $0.backgroundColor = .brandWhite
        $0.rowHeight = 60
        $0.register(SearchUserCell.self, forCellReuseIdentifier: SearchUserCell.id)
    }
    
    override func addSubviews() {
        addSubviews([searchBar, tableView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(5)
            $0.horizontalEdges.equalTo(safeArea)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
