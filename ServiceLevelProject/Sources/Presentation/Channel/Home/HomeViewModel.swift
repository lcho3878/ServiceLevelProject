//
//  HomeViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ChannelTestData {
    let channelName: String
    let unreadCount: Int
}

struct DirectMessageTestData {
    let chatProfileImage: String
    let chatFriendName: String
    let unreadCount: Int
}

final class HomeViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let channelList = BehaviorSubject(value: [
            ChannelTestData(channelName: "일반", unreadCount: 0),
            ChannelTestData(channelName: "스유 뽀개기", unreadCount: 99)
        ])
        
        let chatList = BehaviorSubject(value: [
            DirectMessageTestData(chatProfileImage: "star.fill", chatFriendName: "Hue", unreadCount: 8),
            DirectMessageTestData(chatProfileImage: "heart.fill", chatFriendName: "Jack", unreadCount: 3),
            DirectMessageTestData(chatProfileImage: "leaf.fill", chatFriendName: "Bran", unreadCount: 0),
            DirectMessageTestData(chatProfileImage: "person.fill", chatFriendName: "Den", unreadCount: 1)
        ])
    }
    
    func transform(input: Input) -> Output {
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
                        // 아직 로그아웃 시, 삭제하는 코드 없는 관계로 다른 아이디로 로그인해도 이전 아이디 워크스페이스 뜰 수 있음.
                        UserDefaultManager.workspaceID = firstWorkspace.workspace_id
                        // HomeView 띄우기
                    }
                } else {
                    // EmptyView 띄우기
                }
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
