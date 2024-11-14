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
}
