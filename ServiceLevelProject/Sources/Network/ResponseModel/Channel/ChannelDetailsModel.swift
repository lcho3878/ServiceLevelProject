//
//  ChannelDetailsModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/23/24.
//

import Foundation

struct ChannelDetailsModel: Decodable {
    let channelID: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerID: String
    let createdAt: String
    let channelMembers: [ChannelMembers]
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case ownerID = "owner_id"
        case name, description, coverImage, createdAt, channelMembers
    }
    
    struct ChannelMembers: Decodable {
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
