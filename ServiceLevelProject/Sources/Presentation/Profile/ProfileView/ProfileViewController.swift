//
//  ProfileViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController, DismissButtonPresentable {
    private let profileView = ProfileView()
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    var userID: String?
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        bind()
    }
    
    override func configureNavigation() {
        title = "프로필"
    }
}

extension ProfileViewController {
    private func bind() {
        let input = ProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        
        if let userID = userID {
            input.userID.onNext(userID)
        }
        
        output.targetUserInfo
            .bind(with: self) { owner, info in
                DispatchQueue.main.async {
                    if let image = info.image {
                        owner.profileView.profileImageView.image = UIImage(data: image)
                    }
                    
                    owner.profileView.nicknameLabel.text = info.nickname
                    owner.profileView.emailLabel.text = info.email
                }
            }
            .disposed(by: disposeBag)
    }
}
