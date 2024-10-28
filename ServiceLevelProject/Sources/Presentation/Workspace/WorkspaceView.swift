//
//  WorkspaceView.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class WorkspaceView: BaseView {
    // MARK: UI
    private let bgView = UIView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 25
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
    }
    
    private let topTitleView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
        $0.layer.cornerRadius = 25
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner)
    }
    
    private let topTitleLabel = UILabel().then {
        $0.text = "워크스페이스"
        $0.font = .title1
    }
    
    private let workspaceEmptyView = UIView().then {
        $0.backgroundColor = .systemBrown
    }

    override func addSubviews() {
        addSubviews([bgView, topTitleView, workspaceEmptyView])
        topTitleView.addSubview(topTitleLabel)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        bgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topTitleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(130)
        }
        
        topTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(topTitleView.snp.bottom).offset(-20)
            $0.leading.equalTo(topTitleView.snp.leading).offset(30)
        }
        
        workspaceEmptyView.snp.makeConstraints {
            $0.
        }
    }
    
    override func configureUI() {
        backgroundColor = .clear
    }
}
