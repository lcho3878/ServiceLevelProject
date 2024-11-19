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
    let chattingRoomInfo = BehaviorSubject(value: SearchChannelViewModel.selectedChannelData(name: "", channelID: ""))
    
    struct Input {
        
    }
    
    struct Output {
        let chattingRoomInfo: BehaviorSubject<SearchChannelViewModel.selectedChannelData>
    }
    
    func transform(input: Input) -> Output {
        return Output(chattingRoomInfo: chattingRoomInfo)
    }
}
