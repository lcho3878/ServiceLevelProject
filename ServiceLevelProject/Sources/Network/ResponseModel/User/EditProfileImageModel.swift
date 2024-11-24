//
//  EditProfileImageModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation

struct EditProfileImageModel: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String
    let provider: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, provider, createdAt
    }
}
