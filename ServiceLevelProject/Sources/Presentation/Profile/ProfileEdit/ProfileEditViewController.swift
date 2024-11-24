//
//  ProfileEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditViewController: BaseViewController {
    private let profileEditView = ProfileEditView()
    private let viewModel = ProfileEditViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = profileEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureNavigation() {
        title = "내 정보 수정"
    }
}

extension ProfileEditViewController {
    func bind() {
        let input = ProfileEditViewModel.Input(logoutButtonTap: profileEditView.logoutButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        profileEditView.chargeButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CoinShopViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        profileEditView.nicknameButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = NicknameEditViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        profileEditView.contactButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = PhoneNumberEditViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.logoutAlert
            .bind(with: self) { owner, value in
                let (title, subtitle, buttonTitle) = value
                let alert = DoubleButtonAlertViewController()
                alert.modalPresentationStyle = .overFullScreen
                alert.setConfigure(title: title, subTitle: subtitle, buttonTitle: buttonTitle) { [weak self] in
                    UserDefaultManager.removeUserData()
                    self?.changeRootViewController(rootVC: OnboardingViewController())
                }
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
