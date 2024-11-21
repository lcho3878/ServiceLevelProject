//
//  SettingChannelViewModel.swift.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingChannelViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let chattingRoomInfo = BehaviorSubject(value: SearchChannelViewModel.selectedChannelData(name: "", channelID: "", ownerID: ""))
        let deleteChannelButtonTap: ControlEvent<Void>
        let deleteChannelCheckAlertMessage = PublishSubject<String>()
        let deleteChannelAction = PublishSubject<Void>()
        let deleteFailMessage = PublishSubject<String>()
        let deleteSuccessNavigate = PublishSubject<Void>()
        let leaveChannelButtonTap: ControlEvent<Void>
        let exitChannel = PublishSubject<Void>()
    }
    
    struct Output {
        let userOutput = BehaviorSubject(value: UserTestData.dummy)
        let deleteChannelCheckAlertMessage: PublishSubject<String>
        let deleteFailMessage: PublishSubject<String>
        let deleteSuccessNavigate: PublishSubject<Void>
        let isOwner: PublishSubject<(Bool, String, String, String)>
        let exitChannelSuccessful: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        let isOwner = PublishSubject<(Bool, String, String, String)>()
        let exitChannelSuccessful = PublishSubject<Void>()
        
        input.deleteChannelButtonTap
            .bind(with: self) { owner, _ in
                input.deleteChannelCheckAlertMessage.onNext("정말 이 채널을 삭제하시겠습니까? 삭제 시 멤버/채팅 등\n채널 내의 모든 정보가 삭제되며 복구할 수 없습니다.")
            }
            .disposed(by: disposeBag)
        
        input.deleteChannelAction
            .withLatestFrom(input.chattingRoomInfo)
            .flatMap { value in
                return APIManager.shared.callRequest(api: ChannelRouter.deleteChannel(workspaceID: UserDefaultManager.workspaceID ?? "", channelID: value.channelID))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    input.deleteSuccessNavigate.onNext(())
                case .failure(_):
                    input.deleteFailMessage.onNext("채널 삭제에 실패했습니다. 잠시 후 다시 시도해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        input.leaveChannelButtonTap
            .withLatestFrom(input.chattingRoomInfo)
            .bind(with: self) { owner, roomInfo in
                if UserDefaultManager.userID == roomInfo.ownerID {
                    isOwner.onNext((true, "채널에서 나가기", "회원님은 채널 관리자 입니다. 채널 관리자를 다른 멤버로\n변경한 후 나갈 수 있습니다.", "확인"))
                } else {
                    isOwner.onNext((false, "채널에서 나가기", "나가기를 하면 채널 목록에서 삭제됩니다.", "나가기"))
                }
            }
            .disposed(by: disposeBag)
        
        input.exitChannel
            .withLatestFrom(input.chattingRoomInfo)
            .flatMap { value in
                return APIManager.shared.callRequest(api: ChannelRouter.exitChannel(workspaceID: UserDefaultManager.workspaceID ?? "", channelID: value.channelID), type: [ChannelListModel].self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(_):
                    exitChannelSuccessful.onNext(())
                case .failure(let failure):
                    print(">>> failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
            
        return Output(
            deleteChannelCheckAlertMessage: input.deleteChannelCheckAlertMessage,
            deleteFailMessage: input.deleteFailMessage,
            deleteSuccessNavigate: input.deleteSuccessNavigate,
            isOwner: isOwner,
            exitChannelSuccessful: exitChannelSuccessful
        )
    }
}

extension SettingChannelViewModel {
    struct UserTestData {
        static let dummy: [Int] = .init(repeating: 0, count: 40)
    }
}
