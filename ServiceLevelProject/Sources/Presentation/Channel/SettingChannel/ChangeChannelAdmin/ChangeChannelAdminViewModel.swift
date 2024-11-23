//
//  ChangeChannelAdminViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeChannelAdminViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let memberData = PublishSubject<[ChannelDetailsModel.ChannelMembers]>()
        let ownerID = PublishSubject<String>()
        let nonOwnerMembers = BehaviorSubject(value: [MemberData(nickname: "", email: "", profileImage: nil)])
    }
    
    struct Output {
        let nonOwnerMembers: BehaviorSubject<[MemberData]>
        let isOwnerOnly: BehaviorSubject<(String, String, String)>
    }
    
    func transform(input: Input) -> Output {
        var nonOwnerMembers: [MemberData] = []
        let isOwnerOnly = BehaviorSubject(value: ("", "", ""))
        
        
        Observable.combineLatest(input.memberData, input.ownerID)
            .bind(with: self) { owner, value in
                let (memberData, ownerID) = value
                nonOwnerMembers = []
                for member in memberData {
                    if member.userID != ownerID {
                        nonOwnerMembers.append(MemberData(nickname: member.nickname, email: member.email, profileImage: member.profileImage))
                    }
                }
                print(">>> noneOwnerMemebers: \(nonOwnerMembers)")
                
                if !nonOwnerMembers.isEmpty {
                    input.nonOwnerMembers.onNext(nonOwnerMembers)
                } else {
                    isOwnerOnly.onNext(("채널 관리자 변경 불가", "채널 멤버가 없어 관리자 변경을 할 수 없습니다.", "확인"))
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            nonOwnerMembers: input.nonOwnerMembers,
            isOwnerOnly: isOwnerOnly
        )
    }
}

struct MemberData {
    let nickname: String
    let email: String
    let profileImage: String?
}
