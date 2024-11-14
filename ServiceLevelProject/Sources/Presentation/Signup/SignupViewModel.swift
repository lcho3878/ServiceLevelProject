//
//  SignupViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignupViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let contactText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let passwordCheckText: ControlProperty<String>
        let isSigningUp = PublishSubject<Void>()
        let isEmailChecked = PublishSubject<Bool>()
        let signUpButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailFieldEmpty: Observable<Bool>
        let emailValidation: Observable<Bool>
        let areAllFieldsFilled: Observable<Bool>
        let isSignUpCompleted: PublishSubject<Void>
        let validErrorOutput: PublishSubject<[ValidError]>
    }
    
    func transform(input: Input) -> Output {
        let isEmailFieldEmpty = input.emailText
            .map { self.isEmptyTextField($0) }
        
        let isNicknameFieldEmpty = input.nicknameText
            .map { self.isEmptyTextField($0) }
        
        let isContactFieldEmpty = input.contactText
            .map { self.isEmptyTextField($0) }
        
        let isPasswordFieldEmpty = input.passwordText
            .map { self.isEmptyTextField($0) }
        
        let isPasswordCheckFieldEmpty = input.passwordCheckText
            .map { self.isEmptyTextField($0) }
        
        let emailValidation = input.emailText
            .map { self.validateEmail($0) }
        
        let nicknameValidation = input.nicknameText
            .map { self.validateNickname($0) }
        
        let contactValidation = input.contactText
            .map { self.validateContact($0) }
        
        let passwordValidation = input.passwordText
            .map { self.validatePassword($0) }
        
        let passwordCheckValidation = validatePasswordCheck(password: input.passwordText, passwordCheck: input.passwordCheckText)
        
        let areAllFieldsFilled = Observable
            .combineLatest(isEmailFieldEmpty, isNicknameFieldEmpty, isContactFieldEmpty, isPasswordFieldEmpty, isPasswordCheckFieldEmpty)
            .map { !$0 && !$1 && !$2 && !$3 && !$4 }
            .distinctUntilChanged()
        
        let isSignUpCompleted = PublishSubject<Void>()
        
        input.isSigningUp
            .withLatestFrom(Observable.combineLatest(
                input.emailText,
                input.nicknameText,
                input.contactText,
                input.passwordText)
            )
            .flatMap { email, nickname, contact, password in
                let signUpQuery = SignUp(email: email, password: password, nickname: nickname, phone: contact, deviceToken: UserDefaultManager.fcmToken ?? "")
                return APIManager.shared.callRequest(api: UserRouter.signUp(query: signUpQuery), type: SignUpModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    print("")
                    isSignUpCompleted.onNext(())
                case .failure(let failure):
                    print(">>> fail!!: \(failure)") // 실패 로직 필요
                }
            }
            .disposed(by: disposeBag)
        
        var validError: [ValidError] = []
        let validErrorOutput = PublishSubject<[ValidError]>()
        
        input.signUpButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.emailText, // value.0
                emailValidation, // value.1
                nicknameValidation, // value.2
                contactValidation, // value.3
                passwordValidation, // value.4
                passwordCheckValidation) // value.5
            )
            .bind(with: self) { owner, value in
                validError = []
                
                if value.0 != UserDefaultManager.checkedEmail {
                    validError.append(.emailValid)
                }
                if !value.1 {
                    validError.append(.email)
                }
                if !value.2 {
                    validError.append(.nickname)
                }
                if !value.3 {
                    validError.append(.contact)
                }
                if !value.4 {
                    validError.append(.password)
                }
                if !value.5 {
                    validError.append(.passwordCheck)
                }
                
                validErrorOutput.onNext(validError)
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailFieldEmpty: isEmailFieldEmpty,
            emailValidation: emailValidation,
            areAllFieldsFilled: areAllFieldsFilled,
            isSignUpCompleted: isSignUpCompleted,
            validErrorOutput: validErrorOutput
        )
    }
}

extension SignupViewModel {
    func isEmptyTextField(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9]+@[A-Za-z0-9]+\\.com$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[A-Za-z가-힣][A-Za-z0-9가-힣]{0,29}$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return nicknamePredicate.evaluate(with: nickname)
    }
    
    func validateContact(_ contact: String) -> Bool {
        let digits = contact.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        let nicknameRegex = "^01[0-9]{1}[0-9]{3,4}[0-9]{4}$"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return nicknamePredicate.evaluate(with: digits)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^[A-Z](?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])[A-Za-z0-9\\W]{7,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func validatePasswordCheck(password: ControlProperty<String>, passwordCheck: ControlProperty<String>) -> Observable<Bool> {
        return Observable.combineLatest(password, passwordCheck)
            .map { password, passwordCheck in
                return password == passwordCheck
            }
    }
}

extension SignupViewModel {
    enum ValidError {
        case emailValid
        case email
        case nickname
        case contact
        case password
        case passwordCheck
        
        var toastMessage: String {
            switch self {
            case .emailValid:
                return "이메일 중복 확인을 진행해주세요."
            case .email:
                return "이메일 형식이 올바르지 않습니다."
            case .nickname:
                return "닉네임은 1글자 이상 30글자 이내로 부탁드려요."
            case .contact:
                return "잘못된 전화번호 형식입니다."
            case .password:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수문자를 설정해주세요."
            case .passwordCheck:
                return "작성하신 비밀번호가 일치하지 않습니다."
            }
        }
    }
}
