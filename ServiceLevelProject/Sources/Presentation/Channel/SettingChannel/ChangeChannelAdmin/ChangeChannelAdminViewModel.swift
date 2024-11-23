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
        let channelID = PublishSubject<String>()
        let nonOwnerMembers = BehaviorSubject(value: [MemberData(nickname: "", email: "", userID: "", profileImage: nil)])
        let tableViewModelSelected: ControlEvent<MemberData>
        let proceedChangeAdmin = PublishSubject<Void>()
    }
    
    struct Output {
        let nonOwnerMembers: BehaviorSubject<[MemberData]>
        let isOwnerOnly: ReplaySubject<(String, String, String)>
        let changeAdminAlert: PublishSubject<(String, String, String, String)>
        let changeAdminSuccessful: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        var nonOwnerMembers: [MemberData] = []
        let isOwnerOnly = ReplaySubject<(String, String, String)>.create(bufferSize: 1)
        let changeAdminAlert = PublishSubject<(String, String, String, String)>()
        let changeAdminSuccessful = PublishSubject<Void>()
        
        Observable.combineLatest(input.memberData, input.ownerID)
            .bind(with: self) { owner, value in
                let (memberData, ownerID) = value
                nonOwnerMembers = []
                for member in memberData {
                    if member.userID != ownerID {
                        nonOwnerMembers.append(MemberData(nickname: member.nickname, email: member.email, userID: member.userID, profileImage: member.profileImage))
                    }
                }
                
                if !nonOwnerMembers.isEmpty {
                    input.nonOwnerMembers.onNext(nonOwnerMembers)
                } else {
                    isOwnerOnly.onNext(("채널 관리자 변경 불가", "채널 멤버가 없어 관리자 변경을 할 수 없습니다.", "확인"))
                }
            }
            .disposed(by: disposeBag)
        
        input.tableViewModelSelected
            .bind(with: self) { owner, memberData in
                changeAdminAlert.onNext(("\(memberData.nickname) 님을 관리자로 저장하시겠습니까?", "채널 관리자는 다음과 같은 권한이 있습니다.", "∙ 채널 이름 또는 설명 변경\n∙채널 삭제", "확인"))
            }
            .disposed(by: disposeBag)
        
        input.proceedChangeAdmin
            .withLatestFrom(Observable.combineLatest(input.tableViewModelSelected, input.channelID))
            .flatMap { value in
                let (selectedData, channelID) = value
                return APIManager.shared.callRequest(api: ChannelRouter.changeAdmin(workspaceID: UserDefaultManager.workspaceID ?? "", channelID: channelID, query: OwnerQuery(owner_id: selectedData.userID)), type: ChannelListModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    changeAdminSuccessful.onNext(())
                case .failure(let failure):
                    print(">>> Failed!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            nonOwnerMembers: input.nonOwnerMembers,
            isOwnerOnly: isOwnerOnly,
            changeAdminAlert: changeAdminAlert,
            changeAdminSuccessful: changeAdminSuccessful
        )
    }
}

struct MemberData {
    let nickname: String
    let email: String
    let userID: String
    let profileImage: String?
}
