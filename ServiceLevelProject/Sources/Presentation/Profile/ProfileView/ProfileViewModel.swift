//
//  ProfileViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let userID = PublishSubject<String>()
        let fetchedUserInfo = PublishSubject<ChattingUserModel>()
    }
    
    struct Output {
        let targetUserInfo: PublishSubject<TargetProfileInfo>
    }
    
    func transform(input: Input) -> Output {
        let targetUserInfo = PublishSubject<TargetProfileInfo>()
        
        input.userID
            .flatMap { id in
                return APIManager.shared.callRequest(api: UserRouter.targetUserProfile(userID: id), type: ChattingUserModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    input.fetchedUserInfo.onNext(success)
                case .failure(let failure):
                    print(">>> Failed!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        input.fetchedUserInfo
            .bind(with: self) { owner, info in
                if let image = info.profileImage {
                    Task {
                        let imageData = try await APIManager.shared.loadImage(image)
                        targetUserInfo.onNext(TargetProfileInfo(image: imageData, nickname: info.nickname, email: info.email))
                    }
                } else {
                    targetUserInfo.onNext(TargetProfileInfo(image: nil, nickname: info.nickname, email: info.email))
                }
            }
            .disposed(by: disposeBag)
        
        return Output(targetUserInfo: targetUserInfo)
    }
}

extension ProfileViewModel {
    struct TargetProfileInfo {
        let image: Data?
        let nickname: String
        let email: String
    }
}
