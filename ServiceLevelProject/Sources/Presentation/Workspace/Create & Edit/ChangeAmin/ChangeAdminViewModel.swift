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
        
    }
    
    struct Output {
        let testData = BehaviorSubject(value: [
            ChangeAdminTestData(profileImage: "star.fill", name: "Courtney Henry", email: "michelle.rivera@example.com"),
            ChangeAdminTestData(profileImage: "leaf.fill", name: "Guy Hawkins", email: "alma.lawson@example.com"),
            ChangeAdminTestData(profileImage: "heart.fill", name: "Brooklyn Simmons", email: "dolores.chambers@example.com"),
            ChangeAdminTestData(profileImage: "person.fill", name: "Wade Warren", email: "jackson.roberts@example.com")
        ])
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
