//
//  ChattingUserRealmModel.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/27/24.
//

import Foundation
import RealmSwift

final class ChattingUserRealmModel: Object {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String
    
    let chats = LinkingObjects(fromType: ChattingRealmModel.self, property: "user")
    
    convenience init(user: ChattingUserModel) {
        self.init()
        self.userID = user.userID
        self.email = user.email
        self.nickname = user.nickname
        self.profileImage = user.profileImage
    }
}

extension ChattingUserRealmModel {
    var chattingUserModel: ChattingUserModel {
        return ChattingUserModel(realmUser: self)
    }
}
