//
//  NicknameEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit

final class NicknameEditViewController: BaseViewController {
    private let nicknameEditView = NicknameEditView()
    
    override func loadView() {
        view = nicknameEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigation() {
        title = "닉네임"
    }
}
