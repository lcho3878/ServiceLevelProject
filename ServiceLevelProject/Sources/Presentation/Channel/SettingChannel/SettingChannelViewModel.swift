//
//  SettingChannelViewModel.swift.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/8/24.
//

import Foundation
import RxSwift

final class SettingChannelViewModel: ViewModelBindable {
    struct Input {
        
    }
    
    struct Output {
        let userOutput = BehaviorSubject(value: UserTestData.dummy)
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension SettingChannelViewModel {
    struct UserTestData {
        static let dummy: [Int] = .init(repeating: 0, count: 40)
    }
}
