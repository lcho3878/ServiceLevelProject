//
//  WorkSpaceInqury.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/22/24.
//

import Foundation

struct WorkSpaceInqury: Decodable {
    let workspace_id: String
    let name: String
    let description: String
    let coverImage: String
    let owner_id: String
    let createdAt: String
    let channels: [ChannelListModel]
    let workspaceMembers: [WorkSpaceMember]
    
    var workspace: WorkSpace {
        let workspace = WorkSpace(workspace_id: workspace_id, name: name, description: description, coverImage: coverImage, owner_id: owner_id, createdAt: createdAt)
        return workspace
    }
}
