//
//  ProfileEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/1/24.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
    private let profileEditView = ProfileEditView()
    
    override func loadView() {
        view = profileEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureNavigation() {
        title = "내 정보 수정"
    }
}

extension ProfileEditViewController {
    func bind() {
        
    }
}
