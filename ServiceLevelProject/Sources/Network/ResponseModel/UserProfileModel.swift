//
//  UserProfileModel.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/23/24.
//

import Foundation

struct UserProfileModel: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String
    let provider: String?
    let sesacCoin: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, provider, sesacCoin, createdAt
    }
}
