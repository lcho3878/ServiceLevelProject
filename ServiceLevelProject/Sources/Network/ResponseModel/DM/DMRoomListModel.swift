//
//  DMRoomListModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/27/24.
//

import Foundation

struct DMRoomListModel: Decodable {
    let roomID: String
    let createdAt: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case createdAt, user
    }
    
    struct User: Decodable {
        let userID: String
        let email: String
        let nickname: String
        let profileImage: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case email, nickname, profileImage
        }
    }
}
