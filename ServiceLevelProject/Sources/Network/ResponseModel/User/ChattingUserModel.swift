//
//  ChattingUserModel.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/25/24.
//

import Foundation

struct ChattingUserModel: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
    
    init(realmUser data: ChattingUserRealmModel) {
        self.userID = data.userID
        self.email = data.email
        self.nickname = data.nickname
        self.profileImage = data.profileImage
    }
}

extension ChattingUserModel {
    var realmUser: ChattingUserRealmModel {
        return ChattingUserRealmModel(user: self)
    }
}
