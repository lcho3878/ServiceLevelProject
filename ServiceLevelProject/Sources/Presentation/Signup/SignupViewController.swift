//
//  SignupViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: BaseViewController, DismissButtonPresentable, KeyboardDismissable {
    private let signupView = SignupView()
    private let viewModel = SignupViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboardOnTap()
        bind()
    }
    
    override func configureNavigation() {
        title = "회원가입"
        setDismissButton()
    }
}

extension SignupViewController {
    func bind() {
        let input = SignupViewModel.Input(
            emailText: signupView.emailTextField.rx.text.orEmpty,
            nicknameText: signupView.nicknameTextField.rx.text.orEmpty,
            contactText: signupView.contactTextField.rx.text.orEmpty,
            passwordText: signupView.passwordTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.emailValidation
            .bind(with: self) { owner, value in
                if value {
                    owner.signupView.emailValidationButton.configuration?.baseBackgroundColor = .brand
                    owner.signupView.emailValidationButton.isEnabled = true
                } else {
                    owner.signupView.emailValidationButton.configuration?.baseBackgroundColor = .brandInactive
                    owner.signupView.emailValidationButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        signupView.emailValidationButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText)
            .bind(with: self) { owner, value in
                owner.dismissKeyboard()
                APIManager.shared.validationEmail(email: value) { result in
                    switch result {
                    case .success(let success):
                        owner.signupView.showToast(message: "사용 가능한 이메일입니다.", bottomOffset: -120)
                    case .failure(let failure):
                        owner.signupView.showToast(message: "사용 불가능한 이메일입니다.", bottomOffset: -120)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
