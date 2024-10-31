//
//  HomeNavigationView.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/31/24.
//

import UIKit
import Then

final class HomeNavigationView: BaseView {
    let naviTitleLabel = UILabel().then {
        $0.text = "No Workspace"
        $0.font = .title1
        $0.textAlignment = .left
        $0.textColor = .textPrimary
        $0.isUserInteractionEnabled = true
    }
    
    let titleView = UIView()
    
    let profileButton = UIButton(type: .custom).then {
        $0.topProfileUI(imageName: "person.fill")
    }
    
    let coverButton = UIButton(type: .custom).then {
        $0.topCoverImageUI(imageName: "leaf.fill")
    }
    
    lazy var leftNaviBarItem = UIBarButtonItem(customView: coverButton).then {
        let currWidth = $0.customView?.widthAnchor.constraint(equalToConstant: 32)
        let currHeight = $0.customView?.heightAnchor.constraint(equalToConstant: 32)
        currWidth?.isActive = true
        currHeight?.isActive = true
    }
    
    lazy var rightNaviBarItem = UIBarButtonItem(customView: profileButton).then {
        let currWidth = $0.customView?.widthAnchor.constraint(equalToConstant: 32)
        let currHeight = $0.customView?.heightAnchor.constraint(equalToConstant: 32)
        currWidth?.isActive = true
        currHeight?.isActive = true
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    private let buttonSpace: CGFloat = 120
    
    override func addSubviews() {
        titleView.addSubview(naviTitleLabel)
    }
    
    override func setConstraints() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        naviTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.widthAnchor.constraint(equalToConstant: screenWidth - buttonSpace),
            naviTitleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            naviTitleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            naviTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            naviTitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
    }
}
