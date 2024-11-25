//
//  WorkspaceSearchUserModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import Foundation

struct WorkspaceSearchUserModel: Decodable {
    let workspaceID: String
    let name: String
    let description: String?
    let coverImage: String
    let ownerID: String
    let createdAt: String
    let channels: [Channels]
    let workspaceMembers: [WorkspaceMembers]
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case ownerID = "owner_id"
        case name, description, coverImage, createdAt, channels, workspaceMembers
    }
    
    struct Channels: Decodable {
        let channelID: String
        let name: String
        let description: String?
        let coverImage: String?
        let ownerID: String
        let createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case channelID = "channel_id"
            case ownerID = "owner_id"
            case name, description, coverImage, createdAt
        }
    }
    
    struct WorkspaceMembers: Decodable {
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
