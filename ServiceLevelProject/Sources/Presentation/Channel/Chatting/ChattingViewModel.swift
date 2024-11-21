//
//  ChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChattingViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let chattingRoomInfo = BehaviorSubject(value: SearchChannelViewModel.selectedChannelData(name: "", channelID: "", ownerID: ""))
    }
    
    struct Output {
        let chattingRoomInfo: BehaviorSubject<SearchChannelViewModel.selectedChannelData>
        let inValidChannelMessage: PublishSubject<(String, String, String)>
    }
    
    func transform(input: Input) -> Output {
        let inValidChannelMessage = PublishSubject<(String, String, String)>()
        
        input.viewDidLoadTrigger
            .withLatestFrom(input.chattingRoomInfo)
            .flatMap { roomInfo in
                return APIManager.shared.callRequest(api: ChannelRouter.fetchChannelChatHistory(cursorDate: self.currentDate(), workspaceID: UserDefaultManager.workspaceID ?? "", ChannelID: roomInfo.channelID), type: [ChannelChatHistoryModel].self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(_):
                    print(">>> 성공!!")
                    // 이 응답값은 추후 소켓통신에 필요한 경우 사용
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                    inValidChannelMessage.onNext(("존재하지 않는 채널", "이미 삭제된 채널입니다! 홈 화면으로 이동합니다.", "확인"))
                }
            }
            .disposed(by: disposeBag)
        
        return Output(chattingRoomInfo: input.chattingRoomInfo, inValidChannelMessage: inValidChannelMessage)
    }
}

extension ChattingViewModel {
    private func currentDate() -> String {
        if let timeZone = TimeZone(identifier: "Asia/Seoul") {
            let date = ISO8601DateFormatter.string(from: Date(), timeZone: timeZone)
            return date
        } else {
            print("currentDate() 메서드 정보 받아올 수 없음")
        }
        
        return ""
    }
}
