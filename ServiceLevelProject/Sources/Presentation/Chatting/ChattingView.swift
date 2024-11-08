//
//  ChattingView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit
import SnapKit
import Then

final class ChattingView: BaseView {
    let chattingTableView = UITableView().then {
        $0.backgroundColor = .red
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.id)
    }
    
    private let buttonView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    override func addSubviews() {
        addSubviews([
            chattingTableView,
            buttonView
        ])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        
        buttonView.snp.makeConstraints {
            $0.height.equalTo(38)
            $0.horizontalEdges.equalTo(safe).inset(16)
            $0.bottom.equalTo(safe).inset(12)
        }
        
        chattingTableView.snp.makeConstraints {
            $0.top.equalTo(safe).offset(16)
            $0.horizontalEdges.equalTo(safe)
            $0.bottom.equalTo(buttonView.snp.top)
        }
    }
}
