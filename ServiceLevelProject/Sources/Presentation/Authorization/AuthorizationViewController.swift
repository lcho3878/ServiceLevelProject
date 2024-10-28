//
//  AuthorizationViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthorizationViewController: BaseViewController {

    private let authorizationView = AuthorizationView()
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = authorizationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

extension AuthorizationViewController {
    private func bind() {
        authorizationView.appleButton.rx.tap
            .bind(with: self) { owner, _ in
                print("Apple Button Tap")
            }
            .disposed(by: disposeBag)
        
        authorizationView.kakaoButton.rx.tap
            .bind(with: self) { owner, _ in
                print("Kakao Button Tap")
            }
            .disposed(by: disposeBag)
        
        authorizationView.emailButton.rx.tap
            .bind(with: self) { owner, _ in
                print("Email Button Tap")
            }
            .disposed(by: disposeBag)
        
        authorizationView.signupButton.rx.tap
            .bind(with: self) { owner, _ in
                print("Signup Button Tap")
            }
            .disposed(by: disposeBag)
    }
}

