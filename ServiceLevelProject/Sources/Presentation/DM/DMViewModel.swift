//
//  DMViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import Foundation
import RxSwift
import RxCocoa

struct MemberListTestData {
    let profileImage: String
    let userName: String
}

struct DMListTestData {
    let profileImage: String
    let userName: String
    let lastChat: String
    let lastChatDate: String
    let unreadCount: Int
}

final class DMViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let memberList = BehaviorSubject(value: [
            MemberListTestData(profileImage: "heart.fill", userName: "뚜비두밥"),
            MemberListTestData(profileImage: "person.fill", userName: "고래밥"),
            MemberListTestData(profileImage: "leaf.fill", userName: "카스타드"),
            MemberListTestData(profileImage: "star.fill", userName: "Hue"),
            MemberListTestData(profileImage: "paperplane.fill", userName: "Jack"),
            MemberListTestData(profileImage: "figure.walk", userName: "Dan"),
            MemberListTestData(profileImage: "figure.wave", userName: "Bran"),
            MemberListTestData(profileImage: "figure.dance", userName: "ChanHo")
        ])
        
        let dmList = BehaviorSubject(value: [
            DMListTestData(profileImage: "paperplane.fill", userName: "Jack", lastChat: "오늘 정말 고생 많으셨습니다~!!", lastChatDate: "PM 11:23", unreadCount: 8),
            DMListTestData(profileImage: "star.fill", userName: "Hue", lastChat: "Cause I Know what you like boy You're my chemical hype boy 내 지난날들은 눈 뜨면 잊는 꿈 Hype boy 너만원만줘 Hype boy 너만원만줘 Hype boy 너만원만줘", lastChatDate: "PM 06:33", unreadCount: 1),
            DMListTestData(profileImage: "figure.walk", userName: "Dan", lastChat: "수료식 잊지 않으셨죠?", lastChatDate: "AM 05:08", unreadCount: 0),
            DMListTestData(profileImage: "star.fill", userName: "캠퍼스 좋아", lastChat: "이력서와 포트폴리오 파일입니다!", lastChatDate: "2024년 10월 20일", unreadCount: 0),
            DMListTestData(profileImage: "person.fill", userName: "고래밥", lastChat: "사진", lastChatDate: "2024년 10월 3일", unreadCount: 4)
        ])
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
