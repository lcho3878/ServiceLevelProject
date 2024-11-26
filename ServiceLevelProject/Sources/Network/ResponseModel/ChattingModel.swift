//
//  ChannelChatHistoryModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/22/24.
//

import Foundation

struct ChattingModel: Decodable {
    let id: String
    let content: String
    let createdAt: String
    let files: [String]
    let user: ChattingUserModel
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case content
        case createdAt
        case files
        case user
        case roomID = "room_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.files = try container.decode([String].self, forKey: .files)
        self.user = try container.decode(ChattingUserModel.self, forKey: .user)
        if let channelID = try? container.decode(String.self, forKey: .channelID) {
            self.id = channelID
        } else {
            self.id = try container.decode(String.self, forKey: .roomID)
        }
    }
}
