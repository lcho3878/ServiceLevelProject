//
//  SignupViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit

final class SignupViewController: BaseViewController {
    private let signupView = SignupView()
    
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigation() {
        title = "회원가입"
    }
}
