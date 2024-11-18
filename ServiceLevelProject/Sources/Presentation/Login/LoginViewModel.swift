//
//  LoginViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let loginButtonTap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let isLoggingIn = PublishSubject<Void>()
        let isLoginSuccessful = PublishSubject<Void>()
    }
    
    struct Output {
        let toastMassage: PublishSubject<[LoginError]>
        let isLoginSuccessful: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        let emailValidation = input.emailText
            .map { self.validateEmail($0) }
        
        let passwordValidation = input.passwordText
            .map { self.validatePassword($0) }
        
        var errors: [LoginError] = []
        let loginErrorOutput = PublishSubject<[LoginError]>()
        
        // 로그인 버튼 클릭
        input.loginButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(emailValidation, passwordValidation, input.emailText, input.passwordText))
            .bind(with: self) { owner, value in
                errors = []
                
                if !value.0 {
                    errors.append(.emailValid)
                }
                
                if !value.1 {
                    errors.append(.passwordValid)
                }
                
                loginErrorOutput.onNext(errors)
            }
            .disposed(by: disposeBag)
        
        // 유효성 검증 통과 후, 로그인 네트워크 통신
        input.isLoggingIn
            .withLatestFrom(Observable.combineLatest(input.emailText, input.passwordText))
            .flatMapLatest { email, password -> Single<Result<UserModel, ErrorModel>> in
                let query = LoginQuery(email: email, password: password, deviceToken: UserDefaultManager.fcmToken ?? "")
                return APIManager.shared.callRequest(api: UserRouter.login(query: query), type: UserModel.self)
            }
            .bind(with: self) { owner, result in
                errors = []
                
                switch result {
                case .success(let success):
                    UserDefaultManager.accessToken = success.token.accessToken
                    UserDefaultManager.refreshToken = success.token.refreshToken
                    input.isLoginSuccessful.onNext(())
                case .failure(let failure):
                    errors.append(.loginFailed)
                    loginErrorOutput.onNext(errors)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            toastMassage: loginErrorOutput,
            isLoginSuccessful: input.isLoginSuccessful)
    }
}

extension LoginViewModel {
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9]+@[A-Za-z0-9]+\\.com$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^[A-Z](?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])[A-Za-z0-9\\W]{7,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

extension LoginViewModel {
    enum LoginError {
        case emailValid
        case passwordValid
        case loginFailed
        case etc
        
        var message: String {
            switch self {
            case .emailValid:
                return "이메일 형식이 올바르지 않습니다."
            case .passwordValid:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
            case .loginFailed:
                return "이메일 또는 비밀번호가 올바르지 않습니다."
            case .etc:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            }
        }
    }
}
