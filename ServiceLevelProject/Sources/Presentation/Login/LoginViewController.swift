//
//  LoginViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    // MARK: Functions
    override func configureNavigation() {
        title = "이메일 로그인"
        setDismissButton()
    }
}

extension LoginViewController {
    private func bind() {
        let input = LoginViewModel.Input(
            loginButtonTap: loginView.loginButton.rx.tap,
            emailText: loginView.emailTextField.rx.text.orEmpty,
            passwordText: loginView.passwordTextField.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        // 유효성 검증 토스트 메세지
        output.toastMassage
            .bind(with: self) { owner, errors in
                if errors.isEmpty {
                    input.isLoggingIn.onNext(())
                    return
                }
                
                for error in errors {
                    owner.loginView.showToast(message: error.message, bottomOffset: -120)
                    
                    switch error {
                    case .emailValid:
                        owner.loginView.emailTextField.becomeFirstResponder()
                    case .passwordValid:
                        owner.loginView.passwordTextField.becomeFirstResponder()
                    default:
                        break
                    }
                    
                    break
                }
                
                owner.loginView.emailLabel.textColor = errors.contains(.emailValid) ? .brandError : .brandBlack
                owner.loginView.passwordLabel.textColor = errors.contains(.passwordValid) ? .brandError : .brandBlack
            }
            .disposed(by: disposeBag)
        
        // 로그인 성공 시, 화면전환
        output.isLoginSuccessful
            .bind(with: self) { owner, _ in
                let vc = TabbarViewController()
                owner.changeRootViewController(rootVC: vc, isNavigation: false)
            }
            .disposed(by: disposeBag)
    }
}
