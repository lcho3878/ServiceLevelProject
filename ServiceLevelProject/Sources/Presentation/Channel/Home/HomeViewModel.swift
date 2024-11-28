//
//  HomeViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    let isUpdateChannelList = PublishSubject<Bool>()
    let popFromEditView = PublishSubject<Bool>()
    let viewDidLoadTrigger = PublishSubject<Void>()
    
    struct Input {
        let workspaceID: PublishSubject<String>
        let myChannelList = PublishSubject<[ChannelListModel]>()
        let channelList = BehaviorSubject(value: [ChannelList(channelID: "", name: "", description: nil, coverImage: nil, ownerID: "", createdAt: "", unreadCount: 0)])
        let myChannelIdList = PublishSubject<[String]>()
        let channelTableViewModelSelected: ControlEvent<ChannelList>
        let goToMyChannel = PublishSubject<SelectedChannelData>()
        
        let myDMList = PublishSubject<[DMRoomListModel]>()
        let dmList = BehaviorSubject(value: [DMList(roomID: "", createdAt: "", userID: "", nickname: "", profileImage: nil, unreadCount: 0)])
        let roomIDList = PublishSubject<[String]>()
    }
    
    struct Output {
        let workspaceOutput: PublishSubject<WorkSpace>
        let channelList: BehaviorSubject<[ChannelList]>
        let myChannelIdList: PublishSubject<[String]>
        let goToMyChannel: PublishSubject<SelectedChannelData>
        let profileImageData: PublishSubject<Data>
        let dmList: BehaviorSubject<[DMList]>
        let hasWorkspace: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        var myChannelList: [ChannelListModel] = []
        var myChannelListWithUnreadCount: [ChannelList] = []
        var myChannelIdList: [String] = []
        let profileImage = PublishSubject<String>()
        let profileImageData = PublishSubject<Data>()
        let workspaceIDInput = input.workspaceID.share()
        let workspaceOutput = PublishSubject<WorkSpace>()
        
        var dmList: [DMRoomListModel] = []
        var roomIDList: [String] = []
        var dmWithUnreadCount: [DMList] = []
        
        let hasWorkspace = PublishSubject<Bool>()
        
        viewDidLoadTrigger
            .flatMap { _ in
                return APIManager.shared.callRequest(api: WorkSpaceRouter.list, type: [WorkSpace].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    if !success.isEmpty {
                        if let firstWorkspace = success.first {
                            UserDefaultManager.workspaceID = firstWorkspace.workspace_id
                            hasWorkspace.onNext(true)
                        }
                    } else {
                        hasWorkspace.onNext(false)
                    }
                    
                    if let workspaceID = UserDefaultManager.workspaceID {
                        input.workspaceID.onNext(workspaceID)
                    }
                case .failure(let failure):
                    print(">>> Failed!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        // 내 프로필 정보 조회
        viewDidLoadTrigger
            .flatMap { _ in
                return APIManager.shared.callRequest(api: UserRouter.profile, type: UserProfileModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    if let image = success.profileImage {
                        profileImage.onNext(image)
                    }
                case .failure(let failure):
                    print(">>> Failed! 내정보 조회: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        // 조회된 이미지 방출
        profileImage
            .bind(with: self) { owner, image in
                Task {
                    let data = try await APIManager.shared.loadImage(image)
                    profileImageData.onNext(data)
                    // NotificationCenter 프로필 이미지 전송
                    let imageData: [String: Data] = ["profileData": data]
                    NotificationCenter.default.post(name: .profileImageData, object: nil, userInfo: imageData)
                }
            }
            .disposed(by: disposeBag)
        
        // 워크스페이스 정보 조회
        workspaceIDInput
            .flatMap { id in
                APIManager.shared.callRequest(api: WorkSpaceRouter.inquiry(id: id), type: WorkSpaceInqury.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    let workspace = success.workspace
                    workspaceOutput.onNext(workspace)
                case .failure(let failure):
                    print(">>> Fail!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        // 내가 속한 채널 리스트 조회
        workspaceIDInput
            .flatMap { id in
                return APIManager.shared.callRequest(api: ChannelRouter.myChannelList(workspaceID: id), type: [ChannelListModel].self)
            }
            .bind(with: self) { owner, result in
                myChannelIdList = []
                
                switch result {
                case .success(let succsss):
                    myChannelList = []
                    
                    for channel in succsss {
                        myChannelIdList.append(channel.channelID)
                        myChannelList = succsss
                    }
                    input.myChannelIdList.onNext(myChannelIdList)
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
                
                myChannelIdList = []
                myChannelListWithUnreadCount = []
                
                for channel in success {
                    APIManager.shared.callRequest(api: ChannelRouter.unreadCount(workspaceID: workspaceID, channelID: channel.channelID, after: channel.leaveDate), type: ChannelUnreadCountModel.self) { result in
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
                                
                                myChannelIdList.append(success.channelID)
                            }
                            input.channelList.onNext(myChannelListWithUnreadCount)
                            input.myChannelIdList.onNext(myChannelIdList)
                            
                        case .failure(let failure):
                            print(">>> failure: \(failure.errorCode)")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // isUpdateChannelList가 true인 경우만 넘어옴
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
        
        // 채널 클릭
        input.channelTableViewModelSelected
            .bind(with: self) { owner, channel in
                input.goToMyChannel.onNext(SelectedChannelData(name: channel.name, description: channel.description, channelID: channel.channelID, ownerID: channel.ownerID))
            }
            .disposed(by: disposeBag)
        
        // dm리스트 조회
        workspaceIDInput
            .flatMap { id in
                return APIManager.shared.callRequest(api: DMRouter.dmList(workspaceID: id), type: [DMRoomListModel].self)
            }
            .bind(with: self) { owner, result in
                roomIDList = []
                
                switch result {
                case .success(let success):
                    dmList = []
                    for room in success {
                        roomIDList.append(room.roomID)
                        dmList = success
                    }
                    input.roomIDList.onNext(roomIDList)
                    input.myDMList.onNext(dmList)
                case .failure(let failure):
                    print(">>> Failed!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        // (dm 리스트) + 읽지 않은 채팅 개수
        input.myDMList
            .bind(with: self) { owner, success in
                guard let workspaceID = UserDefaultManager.workspaceID else { return }
                
                dmList = []
                dmWithUnreadCount = []
                guard !success.isEmpty else {
                    input.dmList.onNext(dmWithUnreadCount)
                    input.roomIDList.onNext(roomIDList)
                    return
                }
                for dm in success {
                    APIManager.shared.callRequest(api: DMRouter.unreadCount(workspaceID: workspaceID, roomID: dm.roomID, after: dm.leaveDate), type: DMUnreadCountModel.self) { result in
                        switch result {
                        case .success(let success):
                            if dm.roomID == success.roomID {
                                dmWithUnreadCount.append(DMList(
                                    roomID: dm.roomID,
                                    createdAt: dm.createdAt,
                                    userID: dm.user.userID,
                                    nickname: dm.user.nickname,
                                    profileImage: dm.user.profileImage,
                                    unreadCount: success.count)
                                )
                                
                                roomIDList.append(success.roomID)
                            }
                            input.dmList.onNext(dmWithUnreadCount)
                            input.roomIDList.onNext(roomIDList)
                        case .failure(let failure):
                            print(">>> failure: \(failure.errorCode)")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            workspaceOutput: workspaceOutput,
            channelList: input.channelList,
            myChannelIdList: input.myChannelIdList,
            goToMyChannel: input.goToMyChannel,
            profileImageData: profileImageData,
            dmList: input.dmList,
            hasWorkspace: hasWorkspace
        )
    }
}

struct DMList {
    let roomID: String
    let createdAt: String
    let userID: String
    let nickname: String
    let profileImage: String?
    let unreadCount: Int
    
    var lastChatting: ChattingModel? = nil
}

extension DMList {
    var selectedChannelData: SelectedChannelData {
        return SelectedChannelData(name: nickname, description: nil, channelID: roomID, ownerID: "")
    }
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

struct SelectedChannelData {
    let name: String
    let description: String?
    let channelID: String
    let ownerID: String
}
