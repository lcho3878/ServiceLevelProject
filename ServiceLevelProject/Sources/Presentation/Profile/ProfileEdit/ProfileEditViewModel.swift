//
//  ProfileEditViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileEditViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let logoutButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let logoutAlert: PublishSubject<(String, String, String)>
    }
    
    func transform(input: Input) -> Output {
        let logoutAlert = PublishSubject<(String, String, String)>()
        
        input.logoutButtonTap
            .bind(with: self) { owner, _ in
                logoutAlert.onNext(("로그아웃", "정말 로그아웃 할까요?", "로그아웃"))
            }
            .disposed(by: disposeBag)
        
        return Output(logoutAlert: logoutAlert)
    }
}
