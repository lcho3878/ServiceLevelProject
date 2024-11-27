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
    private var roomID: SelectedChannelData?
    var chattings: [ChattingModel] = []
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let chattingRoomInfo = PublishSubject<SelectedChannelData>()
        let sendMessageText: ControlProperty<String>
        let isPlaceholder = BehaviorSubject<Bool>(value: true)
        let sendButtonTap: ControlEvent<Void>
        let addImageButtonTap: ControlEvent<Void>
        let isImageListEmpty = BehaviorSubject(value: false)
        let imageDataInput: BehaviorSubject<[Data?]>
    }
    
    struct Output {
        let channelName: BehaviorSubject<String>
        let inValidChannelMessage: PublishSubject<(String, String, String)>
        let isEmptyTextView: PublishSubject<Bool>
        let chattingOutput: PublishSubject<[ChattingModel]>
        let imageDataOutput: BehaviorSubject<[Data?]>
        let successOutput: PublishSubject<Void>
        let errorOutput: PublishSubject<ErrorModel>
    }
    
    func transform(input: Input) -> Output {
        let inValidChannelMessage = PublishSubject<(String, String, String)>()
        let channelName = BehaviorSubject(value: "")
        let isEmptyTextView = PublishSubject<Bool>()
        let chattingOutput = PublishSubject<[ChattingModel]>()
        let socketTrigger = PublishSubject<Void>()
        let apiTrigger = PublishSubject<Void>()
        let successOutput = PublishSubject<Void>()
        let errorOutput = PublishSubject<ErrorModel>()
        let chattingQueryInput = Observable.combineLatest(input.sendMessageText, input.imageDataInput, input.isPlaceholder).share()
        let chattingRoomInfo = input.chattingRoomInfo.share()

        editInfo
            .bind(with: self) { owner, editInfo in
                channelName.onNext(editInfo.name)
            }
            .disposed(by: disposeBag)
        
        chattingRoomInfo
            .bind(with: self) { owner, data in
                owner.roomID = data
                RealmRepository.shared.printURL()
            }
            .disposed(by: disposeBag)
        
//        DB에서 가져오기
        chattingRoomInfo
            .bind(with: self) { owner, roomInfo in
                guard let roomID = owner.roomID else { return }
                let chattings = RealmRepository.shared.readChatting(roomID.channelID)
                channelName.onNext(roomInfo.name)
                owner.chattings.append(contentsOf: chattings)
                chattingOutput.onNext(owner.chattings)
                apiTrigger.onNext(())
            }
            .disposed(by: disposeBag)

        // API 통신으로 가져오기
        apiTrigger
            .flatMap { [weak self] in
                guard let roomID = self?.roomID else { return Single<Result<[ChattingModel], ErrorModel>>.never() }
                let cursorDate = self?.chattings.last?.createdAt ?? Date.currentDate()
                return APIManager.shared.callRequest(api: ChannelRouter.fetchChannelChatHistory(cursorDate: cursorDate, workspaceID: UserDefaultManager.workspaceID ?? "", ChannelID: roomID.channelID), type: [ChattingModel].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    print(">>> apichattings \(success)")
                    owner.chattings.append(contentsOf: success)
                    RealmRepository.shared.addChattings(owner.chattings)
                    chattingOutput.onNext(owner.chattings)
                    socketTrigger.onNext(())
                case .failure(let failure):
                    inValidChannelMessage.onNext(("존재하지 않는 채널", "이미 삭제된 채널입니다! 홈 화면으로 이동합니다.", "확인"))
                }
            }
            .disposed(by: disposeBag)
        
        // 소켓으로 채팅 가져오기
        socketTrigger
            .bind(with: self) { owner, _ in
                guard let roodID = owner.roomID else { return }
                WebSocketManager.shared.router = .channel(id: roodID.channelID)
                WebSocketManager.shared.connect()
            }
            .disposed(by: disposeBag)
        
        WebSocketManager.shared.chattingOutput
            .bind(with: self) { owner, chatting in
                RealmRepository.shared.addChatting(chatting)
                owner.chattings.append(chatting)
                chattingOutput.onNext(owner.chattings)
            }
            .disposed(by: disposeBag)

        // 전송버튼 활성화 / 비활성화
        chattingQueryInput
            .bind { (content, datas, isPlaceholder) in
                if content.isEmpty && datas.isEmpty {
                    isEmptyTextView.onNext(true)
                } else if isPlaceholder && datas.isEmpty {
                    isEmptyTextView.onNext(true)
                } else {
                    isEmptyTextView.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        // 전송버튼 클릭
        input.sendButtonTap
            .withLatestFrom(Observable.combineLatest(chattingRoomInfo, chattingQueryInput))
            .flatMap { roomInfo, value in
                let channelID = roomInfo.channelID
                let (content, datas, isPlaceholder) = value
                return APIManager.shared.callRequest(api: ChannelRouter.sendChatting(workspaceID: UserDefaultManager.workspaceID ?? "", channelID: channelID, query: ChattingQuery(content: isPlaceholder ? "" : content, files: datas)), type: ChattingModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    // socket으로 전달이 오기 때문에 수신 필요 X
                    successOutput.onNext(())
                case .failure(let errorModel):
                    errorOutput.onNext(errorModel)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            channelName: channelName,
            inValidChannelMessage: inValidChannelMessage,
            isEmptyTextView: isEmptyTextView,
            chattingOutput: chattingOutput,
            imageDataOutput: input.imageDataInput,
            successOutput: successOutput,
            errorOutput: errorOutput
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
