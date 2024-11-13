//
//  WorkSpace.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/13/24.
//

import Foundation

struct WorkSpace: Decodable {
    let workspace_id: String
    let name: String
    let description: String //Swagger에서는 nil값이 올 수 있지만, 실제로 테스트해본 결과 nil값 오지 않음
    let coverImage: String
    let owner_id: String
    let createdAt: String
}
