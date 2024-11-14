//
//  SignupViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: BaseViewController, DismissButtonPresentable, KeyboardDismissable, RootViewTransitionable {
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
            passwordText: signupView.passwordTextField.rx.text.orEmpty,
            passwordCheckText: signupView.passwordCheckTextField.rx.text.orEmpty,
            signUpButtonTap: signupView.signupButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // 이메일 텍스트필드가 비어있지 Check
        output.isEmailFieldEmpty
            .bind(with: self) { owner, value in
                if !value {
                    owner.signupView.emailValidationButton.configuration?.baseBackgroundColor = .brand
                    owner.signupView.emailValidationButton.isEnabled = true
                } else {
                    owner.signupView.emailValidationButton.configuration?.baseBackgroundColor = .brandInactive
                    owner.signupView.emailValidationButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        // 이메일 중복 확인 버튼
        signupView.emailValidationButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.emailText, output.emailValidation))
            .bind(with: self) { owner, value in
                owner.dismissKeyboard()
                if value.1 {
                    APIManager.shared.validationEmail(email: value.0) { result in
                        switch result {
                        case .success(_):
                            UserDefaultManager.checkedEmail = value.0
                            owner.signupView.showToast(message: "사용 가능한 이메일입니다.", bottomOffset: -120)
                        case .failure(_):
                            owner.signupView.showToast(message: "사용 불가능한 이메일입니다.", bottomOffset: -120)
                        }
                    }
                } else {
                    owner.signupView.showToast(message: "이메일 형식이 올바르지 않습니다.", bottomOffset: -120)
                }
            }
            .disposed(by: disposeBag)
        
        // 가입하기 버튼
        output.validErrorOutput
            .bind(with: self) { owner, validErrors in
                if validErrors.isEmpty {
                    input.isSigningUp.onNext(())
                    return
                }
                
                for error in validErrors {
                    owner.signupView.showToast(message: error.toastMessage, bottomOffset: -120)
                    
                    switch error {
                    case .email:
                        owner.signupView.emailTextField.becomeFirstResponder()
                    case .nickname:
                        owner.signupView.nicknameTextField.becomeFirstResponder()
                    case .contact:
                        owner.signupView.contactTextField.becomeFirstResponder()
                    case .password:
                        owner.signupView.passwordTextField.becomeFirstResponder()
                    default:
                        break
                    }
                    
                    break
                }
                
                owner.signupView.emailLabel.textColor = validErrors.contains(.email) ? .brandError : .brandBlack
                owner.signupView.nicknameLabel.textColor = validErrors.contains(.nickname) ? .brandError : .brandBlack
                owner.signupView.contactLabel.textColor = validErrors.contains(.contact) ? .brandError : .brandBlack
                owner.signupView.passwordLabel.textColor = validErrors.contains(.password) ? .brandError : .brandBlack
                owner.signupView.passwordCheckLabel.textColor = validErrors.contains(.passwordCheck) ? .brandError : .brandBlack
            }
            .disposed(by: disposeBag)
        
        // 모든 텍스트필드가 채워진 경우
        output.areAllFieldsFilled
            .bind(with: self) { owner, value in
                if value {
                    owner.signupView.signupButton.configuration?.baseBackgroundColor = .brand
                    owner.signupView.signupButton.isEnabled = true
                } else {
                    owner.signupView.signupButton.configuration?.baseBackgroundColor = .brandInactive
                    owner.signupView.signupButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        // 회원가입 성공
        output.isSignUpCompleted
            .bind(with: self) { owner, _ in
                // 워크스페이스 "출시 준비 완료!" 화면으로 전환 -> 만들어야함
                // let vc = TabbarViewController()
                // owner.changeRootViewController(rootVC: vc)
                print(">>> 화면전환!")
            }
            .disposed(by: disposeBag)
    }
}
