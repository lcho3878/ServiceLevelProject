//
//  NotificationKey.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/22/24.
//

import Foundation

enum NotificationKey: String {
    case changeAdmin
    case refreshExpiration
    
    var message: String {
        switch self {
        case .changeAdmin:
            return "워크스페이스 관리자가 변경되었습니다."
        case .refreshExpiration:
            return "로그인 정보가 만료되었습니다."
        }
    }
    
    static let toastMessage = "toastMessage"
}
