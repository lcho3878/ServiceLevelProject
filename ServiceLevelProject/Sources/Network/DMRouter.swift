//
//  DMRouter.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/27/24.
//

import Foundation
import Alamofire

enum DMRouter {
    case dmList(workspaceID: String)
    case unreadCount(workspaceID: String, roomID: String, after: String)
}

extension DMRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .dmList, .unreadCount:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .dmList(workspaceID):
            return "/workspaces/\(workspaceID)/dms"
        case let .unreadCount(workspaceID, roomID, _):
            return "/workspaces/\(workspaceID)/dms/\(roomID)/unreads"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .dmList, .unreadCount:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? ""
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case let .unreadCount(_, _,after):
            return [
                "after": after
            ]
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .unreadCount:
            return parameters?.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        default:
            return nil
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var multipartFormData: MultipartFormData? {
        return nil
    }
}
