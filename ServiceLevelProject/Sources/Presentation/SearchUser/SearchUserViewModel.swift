//
//  SearchUserViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchUserViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonClicked: ControlEvent<Void>
        let tableViewModelSelectd: ControlEvent<WorkspaceSearchUserModel.WorkspaceMembers>
    }
    
    struct Output {
        let searchResult: PublishSubject<[WorkspaceSearchUserModel.WorkspaceMembers]>
        let targetUserID: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let searchResult = PublishSubject<[WorkspaceSearchUserModel.WorkspaceMembers]>()
        let targetUserID = PublishSubject<String>()
        
        input.searchButtonClicked
            .withLatestFrom(input.searchText)
            .flatMap { text in
                return APIManager.shared.callRequest(api: WorkSpaceRouter.searchKeyword(workspaceID: UserDefaultManager.workspaceID ?? "", keyword: text), type: WorkspaceSearchUserModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    searchResult.onNext(success.workspaceMembers)
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        input.tableViewModelSelectd
            .bind(with: self) { owner, selectedData in
                targetUserID.onNext(selectedData.userID)
            }
            .disposed(by: disposeBag)
        
        return Output(searchResult: searchResult, targetUserID: targetUserID)
    }
}
