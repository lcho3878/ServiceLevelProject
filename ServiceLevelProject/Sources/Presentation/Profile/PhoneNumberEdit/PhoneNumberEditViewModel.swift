//
//  PhoneNumberEditViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneNumberEditViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let phoneNumberText: ControlProperty<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEmptyPhoneNumber: PublishSubject<Bool>
        let changedPhoneNumber: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let isEmptyPhoneNumber = PublishSubject<Bool>()
        let changedPhoneNumber = PublishSubject<String>()
        
        input.phoneNumberText
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    isEmptyPhoneNumber.onNext(false)
                } else {
                    isEmptyPhoneNumber.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.completeButtonTap
            .withLatestFrom(input.phoneNumberText)
            .flatMap { text in
                return APIManager.shared.callRequest(api: UserRouter.editPhoneNumberProfile(query: EditPhoneNumberQuery(phone: text)), type: EditProfileModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    changedPhoneNumber.onNext(success.phone)
                case .failure(let failure):
                    print("Failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmptyPhoneNumber: isEmptyPhoneNumber,
            changedPhoneNumber: changedPhoneNumber
        )
    }
}

