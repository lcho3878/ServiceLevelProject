//
//  SearchChannelViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import Foundation
import RxSwift
import RxCocoa

struct searchChannelTestData {
    let channelName: String
}

final class SearchChannelViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let searchChannelList = BehaviorSubject(value: [ChannelListModel(channelID: "", name: "", description: nil, coverImage: nil, ownerID: "", createdAt: "")])
    }
    
    struct Output {
        let searchChannelList: BehaviorSubject<[ChannelListModel]>
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
            
        return Output(searchChannelList: input.searchChannelList)
    }
}
