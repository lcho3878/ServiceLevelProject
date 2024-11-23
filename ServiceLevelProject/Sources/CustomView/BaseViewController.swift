//
//  BaseViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/28/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBackButton()
        configureNavigation()
        setupObservers()
    }
    
    func configureNavigation() {}
    private func hideNavigationBackButton() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .brandBlack
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseViewController: RootViewTransitionable {
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshExpirationRecieved),
            name: Notification.Name(NotificationKey.refreshExpiration.rawValue),
            object: nil)
    }
    
    @objc
    private func refreshExpirationRecieved(_ notification: Notification) {
        if let userinfo = notification.userInfo,
           let message = userinfo[NotificationKey.toastMessage] as? String {
            let alert = SingleButtonAlertViewController()
            alert.modalPresentationStyle = .overFullScreen
            alert.setConfigure(mainTitle: "로그인 정보 만료", subTitle: "로그인 화면으로 이동합니다.", buttonTitle: "확인") { [weak self] in
                let vc = OnboardingViewController()
                self?.changeRootViewController(rootVC: vc)
            }
            present(alert, animated: true)
        }
    }
}
