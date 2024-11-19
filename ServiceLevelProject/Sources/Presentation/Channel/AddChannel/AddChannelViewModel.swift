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
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        // 채널 생성 -> 유효성 검증 코드 추가 후, 아래 코드 활성화할 예정
        input.createButtonTap
            // .withLatestFrom(Observable.combineLatest(input.channelNameText, input.channelDescriptionText))
            // .flatMap { value in
            //     return APIManager.shared.callRequest(api: ChannelRouter.addChannel(workspaceID: UserDefaultManager.workspaceID ?? "", query: AddChannelQuery(name: value.0, description: value.1, image: nil)), type: ChannelListModel.self)
            //         .map { result in
            //             switch result {
            //             case .success(let success):
            //                 return success
            //             case .failure(let failure):
            //                 throw failure
            //             }
            //         }
            // }
            .bind(with: self) { owner, value in
                print(">>> value: \(value)")
                // 여기서 dismiss 해주기
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}

