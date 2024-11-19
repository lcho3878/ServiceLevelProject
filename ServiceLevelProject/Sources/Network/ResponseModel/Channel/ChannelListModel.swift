//
//  ChannelListModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/19/24.
//

import Foundation

struct ChannelListModel: Decodable {
    let channelID: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerID: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, description, coverImage
        case ownerID = "owner_id"
        case createdAt
    }
}
