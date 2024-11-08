//
//  SearchChannelViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import Foundation
import RxSwift
import RxCocoa

struct searchChannelTestData {
    let channelName: String
}

final class SearchChannelViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let searchChannelList = BehaviorSubject(value: [
            searchChannelTestData(channelName: "이것이 레거시다"),
            searchChannelTestData(channelName: "취준이직정보방"),
            searchChannelTestData(channelName: "code-review"),
            searchChannelTestData(channelName: "그냥 떠들고 싶을 때"),
            searchChannelTestData(channelName: "노동요 받습니다"),
            searchChannelTestData(channelName: "질의응답"),
            searchChannelTestData(channelName: "테스팅 좋아하는 사람들의 모임"),
            searchChannelTestData(channelName: "모여라 떱떱")
        ])
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
