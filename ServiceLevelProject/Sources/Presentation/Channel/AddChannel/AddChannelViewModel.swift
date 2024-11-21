//
//  AddChannelViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AddChannelViewModel: ViewModelBindable {
    let disposeBag =  DisposeBag()
    
    struct Input {
        let channelNameText: ControlProperty<String>
        let channelDescriptionText: ControlProperty<String>
        let createButtonTap: ControlEvent<Void>
        let isEmptyChannelNameText = PublishSubject<Bool>()
        let toastMessage = PublishSubject<String>()
        let isCreationSuccessful = PublishSubject<Bool>()
    }
    
    struct Output {
        let isEmptyChannelNameText: PublishSubject<Bool>
        let toastMessage: PublishSubject<String>
        let isCreationSuccessful: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        // 채널 생성
        input.createButtonTap
            .withLatestFrom(Observable.combineLatest(input.channelNameText, input.channelDescriptionText))
            .flatMap { value in
                return APIManager.shared.callRequest(api: ChannelRouter.addChannel(workspaceID: UserDefaultManager.workspaceID ?? "", query: AddChannelQuery(name: value.0, description: value.1, image: nil)), type: ChannelListModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    input.isCreationSuccessful.onNext(true)
                case .failure(let error):
                    if error.errorCode == "E12" {
                        input.toastMessage.onNext("워크스페이스에 이미 있는 채널 이름입니다.\n다른 이름을 입력해주세요.")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 생성 버튼 활성화 여부
        input.channelNameText
            .bind(with: self) { owner, value in
                if value.count > 0 {
                    input.isEmptyChannelNameText.onNext(false)
                } else {
                    input.isEmptyChannelNameText.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmptyChannelNameText: input.isEmptyChannelNameText,
            toastMessage: input.toastMessage,
            isCreationSuccessful: input.isCreationSuccessful
        )
    }
}

