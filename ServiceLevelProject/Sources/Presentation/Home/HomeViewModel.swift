//
//  HomeViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ChannelTestData {
    let channelName: String
}

final class HomeViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let channelList = BehaviorSubject(value: [
            ChannelTestData(channelName: "일반"),
            ChannelTestData(channelName: "스유 뽀개기")
        ])
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
