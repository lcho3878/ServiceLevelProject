//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class HomeView: BaseView {
    let naviTitleLabel = UILabel().then {
        $0.text = "No Workspace"
        $0.font = .title1
        $0.textColor = .textPrimary
        $0.isUserInteractionEnabled = true
    }
    
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
    
    override func addSubviews() {
        
    }
    
    override func setConstraints() {
        // let safeArea = safeAreaLayoutGuide
        
    }
    
    override func configureUI() {
        backgroundColor = .brandGray
    }
}
