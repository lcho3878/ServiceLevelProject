//
//  ChattingRealmModel.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/27/24.
//

import Foundation
import RealmSwift

final class ChattingRealmModel: Object {
    @Persisted(primaryKey: true) var obID: ObjectId
    @Persisted var id: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var user: ChattingUserRealmModel?
    
    let container = LinkingObjects(fromType: ChattingContainerRealm.self, property: "id")
    
    convenience init(chatting: ChattingModel) {
        self.init()
        self.content = chatting.content
        self.createdAt = chatting.createdAt
        self.files.append(objectsIn: chatting.files)
        self.user = chatting.user.realmUser
    }
}

extension ChattingRealmModel {
    var chattingModel: ChattingModel {
        return ChattingModel(realmData: self)
    }
}

