//
//  SettingViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let settingList = BehaviorSubject(value: [SettingModel(title: "내 정보 수정"), SettingModel(title: "로그아웃")])
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension SettingViewModel {
    struct SettingModel {
        let title: String
    }
}
