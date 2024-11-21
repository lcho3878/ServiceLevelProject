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
    let roomInfo = BehaviorSubject(value: SearchChannelViewModel.selectedChannelData(name: "", channelID: "", ownerID: ""))
    
    struct Input {
        let deleteChannelButtonTap: ControlEvent<Void>
        let deleteChannelCheckAlertMessage = PublishSubject<String>()
        let deleteChannelAction = PublishSubject<Void>()
        let deleteFailMessage = PublishSubject<String>()
        let deleteSuccessNavigate = PublishSubject<Void>()
    }
    
    struct Output {
        let userOutput = BehaviorSubject(value: UserTestData.dummy)
        let deleteChannelCheckAlertMessage: PublishSubject<String>
        let deleteFailMessage: PublishSubject<String>
        let deleteSuccessNavigate: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        input.deleteChannelButtonTap
            .bind(with: self) { owner, _ in
                input.deleteChannelCheckAlertMessage.onNext("정말 이 채널을 삭제하시겠습니까? 삭제 시 멤버/채팅 등\n채널 내의 모든 정보가 삭제되며 복구할 수 없습니다.")
            }
            .disposed(by: disposeBag)
        
        input.deleteChannelAction
            .withLatestFrom(roomInfo)
            .flatMap { value in
                return APIManager.shared.callRequest(api: ChannelRouter.deleteChannel(workspaceID: UserDefaultManager.workspaceID ?? "", channelID: value.channelID))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    input.deleteSuccessNavigate.onNext(())
                case .failure(let failure):
                    input.deleteFailMessage.onNext("채널 삭제에 실패했습니다. 잠시 후 다시 시도해주세요.")
                }
            }
            .disposed(by: disposeBag)
            
        return Output(
            deleteChannelCheckAlertMessage: input.deleteChannelCheckAlertMessage,
            deleteFailMessage: input.deleteFailMessage,
            deleteSuccessNavigate: input.deleteSuccessNavigate
        )
    }
}

extension SettingChannelViewModel {
    struct UserTestData {
        static let dummy: [Int] = .init(repeating: 0, count: 40)
    }
}
