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
    }
    
    struct Output {
        let emailValidation: Observable<Bool>
        let nicknameValidation: Observable<Bool>
        let contactValidation: Observable<Bool>
        let passwordValidation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let emailValidation = input.emailText
            .map { self.validateEmail($0)}
        
        let nicknameValidation = input.nicknameText
            .map { self.validateNickname($0)}
        
        let contactValidation = input.contactText
            .map { self.validateContact($0)}
        
        let passwordValidation = input.passwordText
            .map { self.validatePassword($0)}
        
        return Output(
            emailValidation: emailValidation,
            nicknameValidation: nicknameValidation,
            contactValidation: contactValidation,
            passwordValidation: passwordValidation
        )
    }
}

extension SignupViewModel {
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
}
