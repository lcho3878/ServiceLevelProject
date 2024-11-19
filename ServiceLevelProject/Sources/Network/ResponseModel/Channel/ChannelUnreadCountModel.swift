//
//  ChannelUnreadCountModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/19/24.
//

import Foundation

struct ChannelUnreadCountModel: Decodable {
    let channelID: String
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, count
    }
}
