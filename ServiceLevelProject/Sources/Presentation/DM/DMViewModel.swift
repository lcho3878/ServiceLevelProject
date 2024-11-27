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
        let viewDidLoadTrigger = PublishSubject<Void>()
        let collectionViewModelSelected: ControlEvent<WorkSpaceMember>
    }
    
    struct Output {
        let memberList: PublishSubject<[WorkSpaceMember]>
        let dmRoomInfo: PublishSubject<DMList>
        
        let dmList = BehaviorSubject(value: [
            DMListTestData(profileImage: "paperplane.fill", userName: "Jack", lastChat: "오늘 정말 고생 많으셨습니다~!!", lastChatDate: "PM 11:23", unreadCount: 8),
            DMListTestData(profileImage: "star.fill", userName: "Hue", lastChat: "Cause I Know what you like boy You're my chemical hype boy 내 지난날들은 눈 뜨면 잊는 꿈 Hype boy 너만원만줘 Hype boy 너만원만줘 Hype boy 너만원만줘", lastChatDate: "PM 06:33", unreadCount: 1),
            DMListTestData(profileImage: "figure.walk", userName: "Dan", lastChat: "수료식 잊지 않으셨죠?", lastChatDate: "AM 05:08", unreadCount: 0),
            DMListTestData(profileImage: "star.fill", userName: "캠퍼스 좋아", lastChat: "이력서와 포트폴리오 파일입니다!", lastChatDate: "2024년 10월 20일", unreadCount: 0),
            DMListTestData(profileImage: "person.fill", userName: "고래밥", lastChat: "사진", lastChatDate: "2024년 10월 3일", unreadCount: 4)
        ])
    }
    
    func transform(input: Input) -> Output {
        let workspaceMemberList = PublishSubject<[WorkSpaceMember]>()
        let userID = PublishSubject<String>()
        let dmRoomInfo = PublishSubject<DMList>()
        
        // 워크스페이스 멤버 조회
        input.viewDidLoadTrigger
            .flatMap { _ in
                return APIManager.shared.callRequest(api: WorkSpaceRouter.memberlist(id: UserDefaultManager.workspaceID ?? ""), type: [WorkSpaceMember].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    workspaceMemberList.onNext(success)
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        // 멤버 셀 클릭
        input.collectionViewModelSelected
            .bind(with: self) { owner, memberInfo in
                userID.onNext(memberInfo.userID)
            }
            .disposed(by: disposeBag)
        
        // DM 방 조회(생성)
        userID
            .flatMap { id in
                return APIManager.shared.callRequest(api: DMRouter.create(workspaceID: UserDefaultManager.workspaceID ?? "", query: CreateDMQuery(opponent_id: id)), type: DMRoomListModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    let roomInfo = DMList(
                        roomID: success.roomID,
                        createdAt: success.createdAt,
                        userID: success.user.userID,
                        nickname: success.user.nickname,
                        profileImage: success.user.profileImage,
                        unreadCount: 0)
                    dmRoomInfo.onNext(roomInfo)
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            memberList: workspaceMemberList,
            dmRoomInfo: dmRoomInfo
        )
    }
}
