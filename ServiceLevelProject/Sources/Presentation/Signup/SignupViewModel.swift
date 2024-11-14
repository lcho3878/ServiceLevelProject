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
    }
    
    struct Output {
        let emailText: ControlProperty<String>
        let isEmailFieldEmpty: Observable<Bool>
        let emailValidation: Observable<Bool>
        let nicknameValidation: Observable<Bool>
        let contactValidation: Observable<Bool>
        let passwordValidation: Observable<Bool>
        let passwordCheckValidation: Observable<Bool>
        let areAllFieldsFilled: Observable<Bool>
        let isSignUpCompleted: PublishSubject<Void>
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
            .withLatestFrom(Observable.combineLatest(input.emailText, input.nicknameText, input.contactText, input.passwordText))
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
        
        
        
        return Output(
            emailText: input.emailText,
            isEmailFieldEmpty: isEmailFieldEmpty,
            emailValidation: emailValidation,
            nicknameValidation: nicknameValidation,
            contactValidation: contactValidation,
            passwordValidation: passwordValidation,
            passwordCheckValidation: passwordCheckValidation,
            areAllFieldsFilled: areAllFieldsFilled,
            isSignUpCompleted: isSignUpCompleted
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
