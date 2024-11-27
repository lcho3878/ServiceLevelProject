//
//  DMUnreadCountModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/27/24.
//

import Foundation

struct DMUnreadCountModel: Decodable {
    let roomID: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case count
    }
}
