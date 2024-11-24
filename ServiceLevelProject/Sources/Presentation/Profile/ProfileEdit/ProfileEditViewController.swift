//
//  ProfileEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class ProfileEditViewController: BaseViewController {
    private let profileEditView = ProfileEditView()
    private let viewModel = ProfileEditViewModel()
    private let disposeBag = DisposeBag()
    
    private var selectedImage = PublishSubject<UIImage?>()
    
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
        
        // viewDidLoadTrigger
        input.viewDidLoadTrigger.onNext(())
        
        // 프로필 정보
        output.profileData
            .bind(with: self) { owner, profileData in
                owner.profileEditView.nicknameLabel.text = profileData.nickname
                owner.profileEditView.contactLabel.text = profileData.phone
                owner.profileEditView.emailLabel.text = profileData.email
                
            }
            .disposed(by: disposeBag)
        
        // 프로필 이미지 불러오기
        output.profileImageData
            .bind(with: self) { owner, imageData in
                DispatchQueue.main.async {
                    owner.profileEditView.profileImageView.image = UIImage(data: imageData)
                }
            }
            .disposed(by: disposeBag)
        
        // 선택한 프로필 이미지
        selectedImage
            .bind(with: self) { owner, image in
                if let selectedImage = image?.jpegData(compressionQuality: 0.6) {
                    input.selectedProfileImage.onNext(selectedImage)
                }
            }
            .disposed(by: disposeBag)
        
        // 프로필 이미지 변경 버튼
        profileEditView.camerButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentPicker()
            }
            .disposed(by: disposeBag)
        
        // 프로필 이미지 변경 성공 메세지
        output.editImageSuccessMessage
            .bind(with: self) { owner, message in
                owner.profileEditView.showToast(message: message, bottomOffset: -120)
            }
            .disposed(by: disposeBag)
        
        // 충전하기 버튼
        profileEditView.chargeButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CoinShopViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 닉네임 수정 버튼
        profileEditView.nicknameButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = NicknameEditViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 연락처 수정 버튼
        profileEditView.contactButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = PhoneNumberEditViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 로그아웃 Alert
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

extension ProfileEditViewController {
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.images
        config.selectionLimit = 1
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func displayImage(with result: PHPickerResult) {
        let itemProvider = result.itemProvider
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self, let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.selectedImage.onNext(image)
                self.profileEditView.profileImageView.image = image
            }
        }
    }
}

extension ProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        if let result = results.first {
            displayImage(with: result)
        } else {
            selectedImage.onNext(nil)
        }
    }
}
