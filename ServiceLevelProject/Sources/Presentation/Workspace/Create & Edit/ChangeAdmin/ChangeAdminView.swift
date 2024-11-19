//
//  ChangeAdminView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/5/24.
//

import UIKit
import SnapKit
import Then

final class ChangeAdminView: BaseView {
    // MARK: UI
    let tableView = UITableView().then {
        $0.register(ChangeAdminCell.self, forCellReuseIdentifier: ChangeAdminCell.id)
        $0.rowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    // MARK: Functions
    override func addSubviews() {
        addSubview(tableView)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(8)
            $0.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
