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
    
    // emptyView
    let emptyView = UIView()
    let noMemberInWorkspaceLabel = UILabel().then {
        $0.text = "워크스페이스에\n멤버가 없어요."
        $0.font = .title1
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .textPrimary
    }
    
    let inviteMemeberLabel = UILabel().then {
        $0.text = "새로운 팀원을 초대해보세요."
        $0.font = .body
        $0.textAlignment = .center
        $0.textColor = .textPrimary
    }
    
    let inviteMemberButton = BrandColorButton(title: "팀원 초대하기")
    
    // nonEmptyView
    let nonEmptyView = UIView()
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
        addSubviews([topDividerView, emptyView, nonEmptyView])
        emptyView.addSubviews([noMemberInWorkspaceLabel, inviteMemeberLabel, inviteMemberButton])
        nonEmptyView.addSubviews([collectionView, memberListDivererView, tableView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(8)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(1)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
        
        noMemberInWorkspaceLabel.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.top).offset(229)
            $0.horizontalEdges.equalTo(emptyView.snp.horizontalEdges).inset(62)
            $0.height.equalTo(60)
        }
        
        inviteMemeberLabel.snp.makeConstraints {
            $0.top.equalTo(noMemberInWorkspaceLabel.snp.bottom).offset(19)
            $0.horizontalEdges.equalTo(emptyView.snp.horizontalEdges).inset(62)
            $0.height.equalTo(18)
        }
        
        inviteMemberButton.snp.makeConstraints {
            $0.top.equalTo(inviteMemeberLabel.snp.bottom).offset(19)
            $0.horizontalEdges.equalTo(emptyView.snp.horizontalEdges).inset(62)
            $0.height.equalTo(44)
        }
        
        nonEmptyView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(nonEmptyView.snp.top)
            $0.horizontalEdges.equalTo(nonEmptyView.snp.horizontalEdges)
            $0.height.equalTo(100)
        }
        
        memberListDivererView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.horizontalEdges.equalTo(nonEmptyView.snp.horizontalEdges)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(memberListDivererView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(nonEmptyView.snp.horizontalEdges)
            $0.bottom.equalTo(nonEmptyView.snp.bottom)
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
