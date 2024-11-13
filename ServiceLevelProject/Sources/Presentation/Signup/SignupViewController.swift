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
            passwordText: signupView.passwordTextField.rx.text.orEmpty,
            passwordCheckText: signupView.passwordCheckTextField.rx.text.orEmpty)
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
        signupView.signupButton.rx.tap
            .withLatestFrom(Observable.combineLatest(output.emailValidation, output.nicknameValidation, output.contactValidation, output.passwordValidation))
            .bind(with: self) { owner, value in
                owner.dismissKeyboard()
                
                var toastMessage: [String] = []
                var firstResponder: [UIResponder] = []
                
                if !value.0 {
                    toastMessage.append("이메일 중복 확인을 진행해주세요.")
                    firstResponder.append(owner.signupView.emailTextField)
                    owner.signupView.emailLabel.textColor = .brandError
                } else {
                    owner.signupView.emailLabel.textColor = .brandBlack
                }
                
                if !value.1 {
                    toastMessage.append("닉네임은 1글자 이상 30글자 이내로 부탁드려요.")
                    firstResponder.append(owner.signupView.nicknameTextField)
                    owner.signupView.nicknameLabel.textColor = .brandError
                } else {
                    owner.signupView.nicknameLabel.textColor = .brandBlack
                }
                
                if !value.2 {
                    toastMessage.append("잘못된 전화번호 형식입니다.")
                    firstResponder.append(owner.signupView.contactTextField)
                    owner.signupView.contactLabel.textColor = .brandError
                } else {
                    owner.signupView.contactLabel.textColor = .brandBlack
                }
                
                if !value.3 {
                    toastMessage.append("비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수문자를 설정해주세요.")
                    firstResponder.append(owner.signupView.passwordTextField)
                    owner.signupView.passwordLabel.textColor = .brandError
                } else {
                    owner.signupView.passwordLabel.textColor = .brandBlack
                }
                
                if !toastMessage.isEmpty {
                    if let message = toastMessage.first, let firstResponder = firstResponder.first {
                        owner.signupView.showToast(message: message, bottomOffset: -120)
                        firstResponder.becomeFirstResponder()
                    }
                } else {
                    input.isSigningUp.onNext(())
                }
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
                // 워크스페이스 "출시 준비 완료!" 화면으로 전환
                print(">>> 화면전환!")
            }
            .disposed(by: disposeBag)
    }
}
