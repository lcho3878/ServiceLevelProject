//
//  SettingView.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import UIKit
import SnapKit
import Alamofire

final class SettingView: BaseView {
    private let topDividerView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 8
        $0.rowHeight = 44
        $0.register(SettingCell.self, forCellReuseIdentifier: SettingCell.id)
        $0.isScrollEnabled = false
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
            $0.top.equalTo(topDividerView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.height.equalTo(88)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
}
