//
//  EditChannelViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditChannelViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let channelNameText: ControlProperty<String>
        let channelDescriptionText: ControlProperty<String>
        let roomInfo = PublishSubject<SelectedChannelData>()
        let completeButtonTap: ControlEvent<Void>
    }

    struct Output {
        let roomInfo: BehaviorSubject<SelectedChannelData>
        let editSuccessful: PublishSubject<ChannelListModel>
    }
    
    func transform(input: Input) -> Output {
        let channelRoomInfo = BehaviorSubject(value: SelectedChannelData(name: "", description: nil, channelID: "", ownerID: ""))
        let editSuccessful = PublishSubject<ChannelListModel>()
        
        input.roomInfo
            .bind(with: self) { owner, roomInfo in
                channelRoomInfo.onNext(roomInfo)
            }
            .disposed(by: disposeBag)
        
        input.completeButtonTap
            .withLatestFrom(Observable.combineLatest(input.roomInfo, input.channelNameText, input.channelDescriptionText))
            .flatMap { value in
                let (roomInfo, name, description) = value
                return APIManager.shared.callRequest(api: ChannelRouter.editChannel(workspaceID: UserDefaultManager.workspaceID ?? "", channelID: roomInfo.channelID, query: ChannelQuery(name: name, description: description, image: nil)), type: ChannelListModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    editSuccessful.onNext(success)
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(roomInfo: channelRoomInfo, editSuccessful: editSuccessful)
    }
}
