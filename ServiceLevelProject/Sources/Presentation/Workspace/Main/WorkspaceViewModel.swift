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
    
    struct Input {}
    
    struct Output {
        let testData = BehaviorSubject(value: [
            WorkspaceTestData(coverImage: "star.fill", title: "iOS_Developer_Study", createdAt: "2024.10.29"),
            WorkspaceTestData(coverImage: "leaf.fill", title: "SeSAC_Study", createdAt: "2023.10.10"),
            WorkspaceTestData(coverImage: "heart.fill", title: "TwoSome_Study", createdAt: "2024.09.10")
        ])
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
