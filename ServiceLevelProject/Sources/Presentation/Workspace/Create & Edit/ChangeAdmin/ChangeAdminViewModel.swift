//
//  ChangeAdminViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeAdminViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let workspaceIDInput: PublishSubject<String>
        let ownerIDInput: PublishSubject<String>
    }
    
    struct Output {
        let membersOutput: PublishSubject<[WorkSpaceMember]>
        let emptyOutput: PublishSubject<Void>
        let successOutput: PublishSubject<Void>
        let errorOutput: PublishSubject<ErrorModel>
    }
    
    func transform(input: Input) -> Output {
        let membersOutput = PublishSubject<[WorkSpaceMember]>()
        let emptyOutput = PublishSubject<Void>()
        let successOutput = PublishSubject<Void>()
        let errorOutput = PublishSubject<ErrorModel>()
        
        input.workspaceIDInput
            .flatMap {
                APIManager.shared.callRequest(api: WorkSpaceRouter.memberlist(id: $0), type: [WorkSpaceMember].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let members):
                    let value = members.filter { $0.userID != UserDefaultManager.userID }
                    if value.isEmpty {
                        emptyOutput.onNext(())
                    } else {
                        membersOutput.onNext(members.filter { $0.userID != UserDefaultManager.userID })
                    }
                case .failure(let errorModel):
                    errorOutput.onNext(errorModel)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.workspaceIDInput, input.ownerIDInput)
            .flatMap { workspaceID, ownerID in
                let query = OwnerQuery(owner_id: ownerID)
                return APIManager.shared.callRequest(api: WorkSpaceRouter.changeOwner(id: workspaceID, query: query), type: WorkSpace.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    successOutput.onNext(())
                case .failure(let errorModel):
                    errorOutput.onNext(errorModel)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            membersOutput: membersOutput,
            emptyOutput: emptyOutput,
            successOutput: successOutput,
            errorOutput: errorOutput
        )
    }
}
