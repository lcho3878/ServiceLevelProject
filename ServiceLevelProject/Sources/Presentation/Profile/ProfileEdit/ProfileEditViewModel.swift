//
//  ProfileEditViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileEditViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    let changedNickname = PublishSubject<String>()
    let changedPhoneNumber = PublishSubject<String>()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let logoutButtonTap: ControlEvent<Void>
        let selectedProfileImage = PublishSubject<Data>()
    }
    
    struct Output {
        let logoutAlert: PublishSubject<(String, String, String)>
        let profileData: PublishSubject<UserProfileModel>
        let profileImageData: PublishSubject<Data>
        let editImageSuccessMessage: PublishSubject<String>
        let changedImageData: PublishSubject<Data>
    }
    
    func transform(input: Input) -> Output {
        let logoutAlert = PublishSubject<(String, String, String)>()
        let profileData = PublishSubject<UserProfileModel>()
        let profileImage = PublishSubject<String>()
        let profileImageData = PublishSubject<Data>()
        let editImageSuccessMessage = PublishSubject<String>()
        let changedProfileImage = PublishSubject<String?>()
        let changedImageData = PublishSubject<Data>()
        
        // 내 프로필 정보 조회
        input.viewDidLoadTrigger
            .flatMap { _ in
                return APIManager.shared.callRequest(api: UserRouter.profile, type: UserProfileModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    profileData.onNext(success)
                    if let image = success.profileImage {
                        profileImage.onNext(image)
                    }
                case .failure(let failure):
                    print(">>> Failed!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        // 조회된 이미지 방출
        profileImage
            .bind(with: self) { owner, image in
                Task {
                    let data = try await APIManager.shared.loadImage(image)
                    profileImageData.onNext(data)
                }
            }
            .disposed(by: disposeBag)
        
        // 내 프로필 이미지 수정
        input.selectedProfileImage
            .flatMap { imageData in
                return APIManager.shared.callRequest(api: UserRouter.editProfileImage(query: ProfileImageQuery(image: imageData)), type: EditProfileModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    changedProfileImage.onNext(success.profileImage)
                    editImageSuccessMessage.onNext("프로필 이미지가 변경되었습니다 :D")
                case .failure(let failure):
                    print(">>> Failed!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        changedProfileImage
            .bind(with: self) { owner, imageString in
                Task {
                    if let image = imageString {
                        let data = try await APIManager.shared.loadImage(image)
                        changedImageData.onNext(data)
                        // NotificationCenter 프로필 이미지 전송
                        let imageData: [String: Data] = ["profileData": data]
                        NotificationCenter.default.post(name: .profileImageData, object: nil, userInfo: imageData)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 로그아웃
        input.logoutButtonTap
            .bind(with: self) { owner, _ in
                logoutAlert.onNext(("로그아웃", "정말 로그아웃 할까요?", "로그아웃"))
            }
            .disposed(by: disposeBag)
        
        return Output(
            logoutAlert: logoutAlert,
            profileData: profileData,
            profileImageData: profileImageData,
            editImageSuccessMessage: editImageSuccessMessage,
            changedImageData: changedImageData
        )
    }
}
