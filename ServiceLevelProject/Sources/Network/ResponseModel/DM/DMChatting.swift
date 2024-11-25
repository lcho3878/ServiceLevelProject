//
//  DMChatting.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/25/24.
//

import Foundation

struct DMChatting: Decodable {
    let dmID: String
    let roomID: String
    let content: String
    let createdAt: String
    let files: [String]
    let user: ChattingUserModel
}
