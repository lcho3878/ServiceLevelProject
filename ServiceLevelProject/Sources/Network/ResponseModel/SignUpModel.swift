//
//  SignUpModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation

struct SignUpModel: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String
    let provider: String?
    let createdAt: String
    let token: Token
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, provider, createdAt, token
    }
    
    struct Token: Decodable {
        let accessToken: String
        let refreshToken: String
    }
}
