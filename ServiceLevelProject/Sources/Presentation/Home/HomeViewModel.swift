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
        return Output()
    }
}
