//
//  DMViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DMViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: PublishSubject<Void>
        let collectionViewModelSelected: ControlEvent<WorkSpaceMember>
    }
    
    struct Output {
        let memberList: PublishSubject<[WorkSpaceMember]>
        let dmRoomInfo: PublishSubject<DMList>
        let dmListOutput: PublishSubject<[DMList]>
    }
    
    func transform(input: Input) -> Output {
        let workspaceMemberList = PublishSubject<[WorkSpaceMember]>()
        let userID = PublishSubject<String>()
        let dmRoomInfo = PublishSubject<DMList>()
        let dmRoomList = PublishSubject<[DMRoomListModel]>()
        let dmListOutput = PublishSubject<[DMList]>()
        var dmList: [DMList] = []
        
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
        
        // DM 방 목록 조회
        input.viewDidLoadTrigger
            .flatMap {
                APIManager.shared.callRequest(api: DMRouter.dmList(workspaceID: UserDefaultManager.workspaceID ?? ""), type: [DMRoomListModel].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    dmRoomList.onNext(success)
                case .failure(let failure):
                    print(">>> DM 목록조회 에러 \(failure)")
                }
            }
            .disposed(by: disposeBag)
        
        // DM 방 별 채팅 + unreadCount 조회
        dmRoomList
            .bind { rooms in
                dmList = []
                for room in rooms {
                    APIManager.shared.callRequest(api: DMRouter.chattingList(workspaceID: UserDefaultManager.workspaceID ?? "", roomID: room.roomID, after: room.leaveDate), type: [ChattingModel].self) { result in
                        switch result {
                        case .success(let success):
                            if let firstChatting = success.first, let lastChatting = success.last {
                                APIManager.shared.callRequest(api: DMRouter.unreadCount(workspaceID: UserDefaultManager.workspaceID ?? "", roomID: room.roomID, after: firstChatting.createdAt), type: DMUnreadCountModel.self) { result in
                                    switch result {
                                    case .success(let success):
                                        let dm = DMList(roomID: room.roomID, createdAt: room.createdAt, userID: room.user.userID, nickname: room.user.nickname, profileImage: room.user.profileImage, unreadCount: success.count + 1, lastChatting: lastChatting)
                                        dmList.append(dm)
                                        dmListOutput.onNext(dmList)
                                    case .failure(let failure):
                                        print(">>> UnreadCount Fail \(failure)")
                                    }
                                }
                            } else {
                                var dm = DMList(roomID: room.roomID, createdAt: room.createdAt, userID: room.user.userID, nickname: room.user.nickname, profileImage: room.user.profileImage, unreadCount: 0)
                                if let lastChatting = RealmRepository.shared.readChatting(room.roomID).last {
                                    dm.lastChatting = lastChatting
                                }
                                dmList.append(dm)
                                dmListOutput.onNext(dmList)
                            }
                        case .failure(let failure):
                            print(">>> DM방별 채팅 내역 조회 실패 \(failure)")
                        }
                    }
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
            dmRoomInfo: dmRoomInfo,
            dmListOutput: dmListOutput
        )
    }
}
