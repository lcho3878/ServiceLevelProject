//
//  AuthorizationViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

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

extension AuthorizationViewController: NavigationRepresentable {
    private func bind() {
        authorizationView.appleButton.rx.tap
            .bind(with: self) { owner, _ in
                let provider = ASAuthorizationAppleIDProvider()

                let request = provider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = owner
                authorizationController.presentationContextProvider = owner
                authorizationController.performRequests()
            }
            .disposed(by: disposeBag)
        
        authorizationView.kakaoButton.rx.tap
            .bind(with: self) { owner, _ in
                print("Kakao Button Tap")
            }
            .disposed(by: disposeBag)
        
        authorizationView.emailButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = LoginViewController()
                owner.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
        
        authorizationView.signupButton.rx.tap
            .bind(with: self) { owner, _ in
                print("Signup Button Tap")
                let vc = SignupViewController()
                owner.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
    }
}

extension AuthorizationViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID: \(userIdentifier)")
            print("Full Name: \(fullName ?? PersonNameComponents())")
            print("Email: \(email ?? "No email")")
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                    let identityToken = appleIDCredential.identityToken,
                    let authCodeString = String(data: authorizationCode, encoding: .utf8),
                    let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                    print("authorizationCode: \(authorizationCode)")
                    print("identityToken: \(identityToken)")
                    print("authCodeString: \(authCodeString)")
                    print("identifyTokenString: \(identifyTokenString)")
                }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 오류: \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

