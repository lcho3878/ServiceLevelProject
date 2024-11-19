//
//  HomeViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

struct DirectMessageTestData {
    let chatProfileImage: String
    let chatFriendName: String
    let unreadCount: Int
}

struct ChannelList {
    let channelID: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerID: String
    let createdAt: String
    let unreadCount: Int
}

final class HomeViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    let isUpdateChannelList = PublishSubject<Bool>()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let workspaceID = PublishSubject<String>()
        let myChannelList = PublishSubject<[ChannelListModel]>()
        let channelList = BehaviorSubject(value: [ChannelList(channelID: "", name: "", description: nil, coverImage: nil, ownerID: "", createdAt: "", unreadCount: 0)])
    }
    
    struct Output {
        let channelList: BehaviorSubject<[ChannelList]>
        
        let chatList = BehaviorSubject(value: [
            DirectMessageTestData(chatProfileImage: "star.fill", chatFriendName: "Hue", unreadCount: 8),
            DirectMessageTestData(chatProfileImage: "heart.fill", chatFriendName: "Jack", unreadCount: 3),
            DirectMessageTestData(chatProfileImage: "leaf.fill", chatFriendName: "Bran", unreadCount: 0),
            DirectMessageTestData(chatProfileImage: "person.fill", chatFriendName: "Den", unreadCount: 1)
        ])
    }
    
    func transform(input: Input) -> Output {
        var myChannelList: [ChannelListModel] = []
        var myChannelListWithUnreadCount: [ChannelList] = []
        
        input.viewDidLoadTrigger
            .flatMap {
                if UserDefaultManager.workspaceID == nil {
                    return APIManager.shared.callRequest(api: WorkSpaceRouter.list, type: [WorkSpace].self)
                        .map { result in
                            switch result {
                            case .success(let workspaces):
                                return workspaces
                            case .failure(let error):
                                throw error
                            }
                        }
                } else {
                    return Single.just([])
                }
            }
            .bind(with: self) { owner, result in
                if !result.isEmpty {
                    if let firstWorkspace = result.first {
                        /// 아직 로그아웃 시, 삭제하는 코드 없는 관계로 다른 아이디로 로그인해도 이전 아이디 워크스페이스 뜰 수 있음.
                        /// (다른 아이디 로그인 시, 기기에서 앱 지우기)
                        UserDefaultManager.workspaceID = firstWorkspace.workspace_id
                    }
                }
                
                if let workspaceID = UserDefaultManager.workspaceID {
                    input.workspaceID.onNext(workspaceID)
                }
            }
            .disposed(by: disposeBag)
        
        // 내가 속한 채널 리스트 조회
        input.workspaceID
            .flatMap { id in
                return APIManager.shared.callRequest(api: ChannelRouter.myChannelList(workspaceID: id), type: [ChannelListModel].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let succsss):
                    myChannelList = []
                    for channel in succsss {
                        myChannelList.append(ChannelListModel(
                            channelID: channel.channelID,
                            name: channel.name,
                            description: channel.description,
                            coverImage: channel.coverImage,
                            ownerID: channel.ownerID,
                            createdAt: channel.createdAt
                        ))
                    }
                    input.myChannelList.onNext(myChannelList)
                case .failure(let failure):
                    print(">>> Fail!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        // (내가 속한 채널 리스트 조회) + 읽지 않은 채널 채팅 개수
        input.myChannelList
            .bind(with: self) { owner, success in
                guard let workspaceID = UserDefaultManager.workspaceID else { return }
                myChannelListWithUnreadCount = []
                for channel in success {
                    APIManager.shared.callRequest(api: ChannelRouter.unreadCount(workspaceID: workspaceID, channelID: channel.channelID, after: channel.createdAt), type: ChannelUnreadCountModel.self) { result in
                        switch result {
                        case .success(let success):
                            if channel.channelID == success.channelID {
                                myChannelListWithUnreadCount.append(ChannelList(
                                    channelID: channel.channelID,
                                    name: channel.name,
                                    description: channel.description,
                                    coverImage: channel.ownerID,
                                    ownerID: channel.ownerID,
                                    createdAt: channel.createdAt,
                                    unreadCount: success.count)
                                )
                            }
                            input.channelList.onNext(myChannelListWithUnreadCount)
                        case .failure(let failure):
                            print(">>> failure: \(failure)")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        isUpdateChannelList
            .flatMap { value in
                return APIManager.shared.callRequest(api: ChannelRouter.myChannelList(workspaceID: UserDefaultManager.workspaceID ?? ""), type: [ChannelListModel].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let succsss):
                    myChannelList = []
                    for channel in succsss {
                        myChannelList.append(ChannelListModel(
                            channelID: channel.channelID,
                            name: channel.name,
                            description: channel.description,
                            coverImage: channel.coverImage,
                            ownerID: channel.ownerID,
                            createdAt: channel.createdAt
                        ))
                    }
                    input.myChannelList.onNext(myChannelList)
                case .failure(let failure):
                    print(">>> Fail!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(channelList: input.channelList)
    }
}
