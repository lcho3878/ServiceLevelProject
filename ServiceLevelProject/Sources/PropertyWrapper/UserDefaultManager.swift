//
//  UserDefaultManager.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/13/24.
//

import Foundation

struct UserDefaultManager {
    @UserDefault(key: "fcmToken", defaultValue: nil)
    static var fcmToken: String?
    
    @UserDefault(key: "checkedEmail", defaultValue: nil)
    static var checkedEmail: String?

    @UserDefault(key: "accessToken", defaultValue: nil)
    static var accessToken: String?
    
    @UserDefault(key: "refreshToken", defaultValue: nil)
    static var refreshToken: String?
    
    @UserDefault(key: "workspaceID", defaultValue: nil)
    static var workspaceID: String?
  
    @UserDefault(key: "userID", defaultValue: nil)
    static var userID: String?
    
    static func saveUserData(user: UserModel) {
        UserDefaultManager.accessToken = user.token.accessToken
        UserDefaultManager.refreshToken = user.token.refreshToken
        UserDefaultManager.userID = user.userID
        //FCM Token 관리시 저장 필요
    }
    
    static func removeUserData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key == "fcmToken" { continue }
            UserDefaults.standard.removeObject(forKey: key)
        }
        RealmRepository.shared.removeAllData()
        UserDefaults.standard.synchronize()
    }
}
