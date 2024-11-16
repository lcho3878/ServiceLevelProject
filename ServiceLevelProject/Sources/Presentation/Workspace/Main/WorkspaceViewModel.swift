//
//  WorkspaceViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/29/24.
//

import Foundation
import RxSwift
import RxCocoa

struct WorkspaceTestData {
    let coverImage: String
    let title: String
    let createdAt: String
}

final class WorkspaceViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    private var workSpacelist: [WorkSpace] = []
    
    struct Input {
        let workspaceLoadTrigger: PublishSubject<Void>
        let workspaceDeleteInput: PublishSubject<String>
    }
    
    struct Output {
        let workspaceList: PublishSubject<[WorkSpace]>
        let testData = BehaviorSubject(value: [
            WorkspaceTestData(coverImage: "star.fill", title: "iOS_Developer_Study", createdAt: "2024.10.29"),
            WorkspaceTestData(coverImage: "leaf.fill", title: "SeSAC_Study", createdAt: "2023.10.10"),
            WorkspaceTestData(coverImage: "heart.fill", title: "TwoSome_Study", createdAt: "2024.09.10")
        ])
    }
    
    func transform(input: Input) -> Output {
        let workspaceList = PublishSubject<[WorkSpace]>()
        input.workspaceLoadTrigger
            .flatMap {
                print(">>> API Call")
                return APIManager.shared.callRequest(api: WorkSpaceRouter.list, type: [WorkSpace].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.workSpacelist = value
                    workspaceList.onNext(owner.workSpacelist)
                case .failure(let errorModel):
                    print(errorModel.errorCode)
                }
            }
            .disposed(by: disposeBag)
        
        input.workspaceDeleteInput
            .flatMap {
                APIManager.shared.callRequest(api: WorkSpaceRouter.delete(id: $0))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    print("success")
                    input.workspaceLoadTrigger.onNext(())
                case .failure(let errorModel):
                    print(">>> Error: \(errorModel.errorCode)")
                }
            }
            .disposed(by: disposeBag)
           
        return Output(workspaceList: workspaceList)
    }
}
