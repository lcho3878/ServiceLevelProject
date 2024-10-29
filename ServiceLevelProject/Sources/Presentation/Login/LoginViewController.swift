//
//  LoginViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit

final class LoginViewController: BaseViewController, DismissButtonPresentable {
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigation() {
        title = "이메일 로그인"
        setDismissButton()
    }
}

