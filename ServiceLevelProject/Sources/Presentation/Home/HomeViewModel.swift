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
}

struct DirectMessageTestData {
    let chatProfileImage: String
    let chatFriendName: String
}

final class HomeViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let channelList = BehaviorSubject(value: [
            ChannelTestData(channelName: "일반"),
            ChannelTestData(channelName: "스유 뽀개기")
        ])
        
        let chatList = BehaviorSubject(value: [
            DirectMessageTestData(chatProfileImage: "star.fill", chatFriendName: "Hue"),
            DirectMessageTestData(chatProfileImage: "heart.fill", chatFriendName: "Jack"),
            DirectMessageTestData(chatProfileImage: "leaf.fill", chatFriendName: "Bran"),
            DirectMessageTestData(chatProfileImage: "person.fill", chatFriendName: "Den")
        ])
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
