//
//  RealmRepository.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/27/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    static let shared = RealmRepository()
    
    private let realm = try! Realm()
    
    private init() {}
    
    func printURL() {
        print(">>> REALM \(realm.configuration.fileURL)")
    }
    
    func addChatting(_ chatting: ChattingModel) {
        try! realm.write({
            let userRealmModel = ChattingUserRealmModel(user: chatting.user)
            realm.add(userRealmModel, update: .modified)
             
             // ChattingRealmModel 생성 및 연결
             let chattingRealmModel = ChattingRealmModel(chatting: chatting)
             chattingRealmModel.user = userRealmModel
             
             // ChattingContainerRealm 처리
             if let container = realm.object(ofType: ChattingContainerRealm.self, forPrimaryKey: chatting.id) {
                 container.chattingList.append(chattingRealmModel)
                 realm.add(container, update: .modified)
             } else {
                 let container = ChattingContainerRealm()
                 container.id = chatting.id
                 container.chattingList.append(chattingRealmModel)
                 realm.add(container, update: .modified)
             }
        })
    }
    
    func addChattings(_ chattings: [ChattingModel]) {
        for chatting in chattings {
            addChatting(chatting)
        }
    }
    
    /// channel, room ID기반 채팅리스트 DB조회
    func readChatting(_ id: String) -> [ChattingModel] {
        if let value = realm.object(ofType: ChattingContainerRealm.self, forPrimaryKey: id) {
            let chattings = Array(value.chattingList.map { $0.chattingModel })
            return chattings
        } else {
            return []
        }
    }
    
    func readleaveDate(_ id: String) -> String? {
        if let container = realm.object(ofType: ChattingContainerRealm.self, forPrimaryKey: id) {
            if let leaveDate = container.leaveDate {
                return leaveDate
            } else {
                return ""
            }
        } else {
            return nil
        }
    }
    
    func updateLeaveDate(_ id: String) {
        if let container = realm.object(ofType: ChattingContainerRealm.self, forPrimaryKey: id) {
            try! realm.write {
                container.leaveDate = Date().asISOSTring()
                realm.add(container, update: .modified)
            }
        }
    }
    
    func removeAllData() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
