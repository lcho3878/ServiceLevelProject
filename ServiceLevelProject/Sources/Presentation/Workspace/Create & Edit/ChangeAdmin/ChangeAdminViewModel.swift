//
//  ChangeAdminViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/5/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ChangeAdminTestData {
    let profileImage: String
    let name: String
    let email: String
}

final class ChangeAdminViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let workspaceIDInput: PublishSubject<String>
    }
    
    struct Output {
        let membersOutput: PublishSubject<[WorkSpaceMember]>
        let emptyOutput: PublishSubject<Void>
        let errorOutput: PublishSubject<ErrorModel>
        let testData = BehaviorSubject(value: [
            ChangeAdminTestData(profileImage: "star.fill", name: "Courtney Henry", email: "michelle.rivera@example.com"),
            ChangeAdminTestData(profileImage: "leaf.fill", name: "Guy Hawkins", email: "alma.lawson@example.com"),
            ChangeAdminTestData(profileImage: "heart.fill", name: "Brooklyn Simmons", email: "dolores.chambers@example.com"),
            ChangeAdminTestData(profileImage: "person.fill", name: "Wade Warren", email: "jackson.roberts@example.com")
        ])
    }
    
    func transform(input: Input) -> Output {
        let membersOutput = PublishSubject<[WorkSpaceMember]>()
        let emptyOutput = PublishSubject<Void>()
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
        return Output(
            membersOutput: membersOutput,
            emptyOutput: emptyOutput,
            errorOutput: errorOutput
        )
    }
}
