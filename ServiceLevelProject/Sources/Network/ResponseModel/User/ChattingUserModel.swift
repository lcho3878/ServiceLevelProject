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
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
    
}
