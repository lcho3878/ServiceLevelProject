//
//  SearchChannelViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchChannelViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    let myChannelIdList = BehaviorSubject(value: [""])
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let searchChannelList = BehaviorSubject(value: [ChannelListModel(channelID: "", name: "", description: nil, coverImage: nil, ownerID: "", createdAt: "")])
        let modelSelected: ControlEvent<ChannelListModel>
        let goToMyChannel = PublishSubject<selectedChannelData>()
        let goToChannelJoin = PublishSubject<selectedChannelData>()
    }
    
    struct Output {
        let searchChannelList: BehaviorSubject<[ChannelListModel]>
        let goToMyChannel: PublishSubject<selectedChannelData>
        let goToChannelJoin: PublishSubject<selectedChannelData>
    }
    
    func transform(input: Input) -> Output {
        var channelList: [ChannelListModel] = []
        
        input.viewDidLoadTrigger
            .flatMap { _ in
                return APIManager.shared.callRequest(api: ChannelRouter.channelList(workspaceID: UserDefaultManager.workspaceID ?? ""), type: [ChannelListModel].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    channelList = []
                    for channel in success {
                        channelList.append(channel)
                    }
                    input.searchChannelList.onNext(channelList)
                case .failure(let failure):
                    print(">>> Failed!!: \(failure)")
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.modelSelected, myChannelIdList)
            .bind(with: self) { owner, value in
                if value.1.contains(value.0.channelID) {
                    // 내 채널인 경우
                    input.goToMyChannel.onNext(selectedChannelData(name: value.0.name, channelID: value.0.channelID))
                } else {
                    // 내 채널이 아닌 경우
                    input.goToChannelJoin.onNext(selectedChannelData(name: value.0.name, channelID: value.0.channelID))
                }
            }
            .disposed(by: disposeBag)
            
        return Output(
            searchChannelList: input.searchChannelList,
            goToMyChannel: input.goToMyChannel,
            goToChannelJoin: input.goToChannelJoin
        )
    }
}

extension SearchChannelViewModel {
    struct selectedChannelData {
        let name: String
        let channelID: String
    }
}
