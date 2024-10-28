//
//  OnboardingViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    
    private let onboardingView = OnboardingView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

extension OnboardingViewController {
    private func bind() {
        onboardingView.loginButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentMediumModal()
            }
            .disposed(by: disposeBag)
    }
}

extension OnboardingViewController {
    private func presentMediumModal() {
        let nextVC = AuthorizationViewController()
        nextVC.modalPresentationStyle = .pageSheet
        guard let sheet = nextVC.sheetPresentationController else { return }
        sheet.detents = [.medium(), .large()]
        present(nextVC, animated: true)
    }
}
