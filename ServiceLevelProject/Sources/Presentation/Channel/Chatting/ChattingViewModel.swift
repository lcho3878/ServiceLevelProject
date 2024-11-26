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
    typealias Chatting = ChannelChatHistoryModel
    let disposeBag = DisposeBag()
    let editInfo = PublishSubject<SelectedChannelData>()
    var roodID: String?
    var chattings: [Chatting] = []
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let chattingRoomInfo = PublishSubject<SelectedChannelData>()
        let sendMessageText: ControlProperty<String>
        let sendButtonTap: ControlEvent<Void>
        let addImageButtonTap: ControlEvent<Void>
        let isImageListEmpty = BehaviorSubject(value: false)
        let imageDataInput: BehaviorSubject<[Data?]>
    }
    
    struct Output {
        let channelName: BehaviorSubject<String>
        let inValidChannelMessage: PublishSubject<(String, String, String)>
        let isEmptyTextView: PublishSubject<Bool>
        let chattingOutput: PublishSubject<[Chatting]>
        let imageDataOutput: BehaviorSubject<[Data?]>
    }
    
    func transform(input: Input) -> Output {
        let inValidChannelMessage = PublishSubject<(String, String, String)>()
        let channelName = BehaviorSubject(value: "")
        let isEmptyTextView = PublishSubject<Bool>()
        let chattingOutput = PublishSubject<[Chatting]>()
        let socketTrigger = PublishSubject<Void>()
        
        editInfo
            .bind(with: self) { owner, editInfo in
                channelName.onNext(editInfo.name)
            }
            .disposed(by: disposeBag)
        
        input.chattingRoomInfo
            .flatMap { [weak self] roomInfo in
                self?.roodID = roomInfo.channelID
                channelName.onNext(roomInfo.name)
                return APIManager.shared.callRequest(api: ChannelRouter.fetchChannelChatHistory(cursorDate: Date.currentDate(), workspaceID: UserDefaultManager.workspaceID ?? "", ChannelID: roomInfo.channelID), type: [ChannelChatHistoryModel].self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    print(">>> Success!")
                    owner.chattings = success
                    chattingOutput.onNext(owner.chattings)
                    socketTrigger.onNext(())
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                    inValidChannelMessage.onNext(("존재하지 않는 채널", "이미 삭제된 채널입니다! 홈 화면으로 이동합니다.", "확인"))
                }
            }
            .disposed(by: disposeBag)
        
        // 전송버튼 활성화 / 비활성화
        Observable.combineLatest(input.sendMessageText, input.imageDataInput)
            .bind { (message, datas) in
                isEmptyTextView.onNext(message.isEmpty && datas.isEmpty)
            }
            .disposed(by: disposeBag)
        
        socketTrigger
            .withLatestFrom(input.chattingRoomInfo)
            .bind(with: self) { owner, roomInfo in
                WebSocketManager.shared.router = .channel(id: roomInfo.channelID)
                WebSocketManager.shared.connect()
            }
            .disposed(by: disposeBag)
        
        WebSocketManager.shared.channelOutput
            .bind(with: self) { owner, chatting in
                owner.chattings.append(chatting)
                chattingOutput.onNext(owner.chattings)
            }
            .disposed(by: disposeBag)
        
        return Output(
            channelName: channelName,
            inValidChannelMessage: inValidChannelMessage,
            isEmptyTextView: isEmptyTextView,
            chattingOutput: chattingOutput,
            imageDataOutput: input.imageDataInput
        )
    }
    
    deinit {
        WebSocketManager.shared.disconnect()
        print(">>> ChattingViewModel - Deinit")
    }
}

extension Date {
    static func currentDate() -> String {
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
