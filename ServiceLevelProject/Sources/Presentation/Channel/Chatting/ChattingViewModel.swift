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
    let editInfo = PublishSubject<SelectedChannelData>()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let chattingRoomInfo = PublishSubject<SelectedChannelData>()
        let sendMessageText: ControlProperty<String>
        let sendButtonTap: ControlEvent<Void>
        let addImageButtonTap: ControlEvent<Void>
        let isImageListEmpty = BehaviorSubject(value: false)
    }
    
    struct Output {
        let channelName: BehaviorSubject<String>
        let inValidChannelMessage: PublishSubject<(String, String, String)>
        let isEmptyTextView: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let inValidChannelMessage = PublishSubject<(String, String, String)>()
        let channelName = BehaviorSubject(value: "")
        let isEmptyTextView = PublishSubject<Bool>()
        
        editInfo
            .bind(with: self) { owner, editInfo in
                channelName.onNext(editInfo.name)
            }
            .disposed(by: disposeBag)
        
        input.chattingRoomInfo
            .flatMap { roomInfo in
                channelName.onNext(roomInfo.name)
                return APIManager.shared.callRequest(api: ChannelRouter.fetchChannelChatHistory(cursorDate: self.currentDate(), workspaceID: UserDefaultManager.workspaceID ?? "", ChannelID: roomInfo.channelID), type: [ChannelChatHistoryModel].self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    print(">>> 성공!!: \(success)")
                    // 이 응답값은 추후 소켓통신에 필요한 경우 사용
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                    inValidChannelMessage.onNext(("존재하지 않는 채널", "이미 삭제된 채널입니다! 홈 화면으로 이동합니다.", "확인"))
                }
            }
            .disposed(by: disposeBag)
        
        // 전송버튼 활성화 / 비활성화
        Observable.combineLatest(input.sendMessageText, input.isImageListEmpty)
            .bind(with: self) { owner, value in
                let (text, image) = value
                if !text.isEmpty || !image {
                    isEmptyTextView.onNext(false)
                } else {
                    isEmptyTextView.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            channelName: channelName,
            inValidChannelMessage: inValidChannelMessage,
            isEmptyTextView: isEmptyTextView
        )
    }
}

extension ChattingViewModel {
    private func currentDate() -> String {
        if let timeZone = TimeZone(identifier: "Asia/Seoul") {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = timeZone
            let date = formatter.string(from: Date())
            return date
        } else {
            print("currentDate() 메서드 정보 받아올 수 없음")
        }
        
        return " "
    }
}
