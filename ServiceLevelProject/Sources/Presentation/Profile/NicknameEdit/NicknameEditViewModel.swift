//
//  NicknameEditViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameEditViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let nickNameText: ControlProperty<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEmptyNickname: PublishSubject<Bool>
        let changedNickname: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let isEmptyNickname = PublishSubject<Bool>()
        let changedNickname = PublishSubject<String>()
        
        input.nickNameText
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    isEmptyNickname.onNext(false)
                } else {
                    isEmptyNickname.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.completeButtonTap
            .withLatestFrom(input.nickNameText)
            .flatMap { text in
                return APIManager.shared.callRequest(api: UserRouter.editNicknameProfile(query: EditNicknameQuery(nickname: text)), type: EditProfileModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    changedNickname.onNext(success.nickname)
                case .failure(let failure):
                    print("Failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmptyNickname: isEmptyNickname,
            changedNickname: changedNickname
        )
    }
}
