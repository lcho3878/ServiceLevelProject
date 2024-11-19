//
//  WorkSpaceMember.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/19/24.
//

import Foundation

struct WorkSpaceMember: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
