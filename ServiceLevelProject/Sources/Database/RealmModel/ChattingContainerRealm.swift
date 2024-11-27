//
//  ChattingContainerRealm.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/27/24.
//

import Foundation
import RealmSwift

final class ChattingContainerRealm: Object {
    @Persisted(primaryKey: true) var id: String // 채널, dm 아이디
    @Persisted var chattingList: List<ChattingRealmModel>
}
