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
    case create(workspaceID: String, query: CreateDMQuery)
}

extension DMRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .dmList, .unreadCount:
            return .get
        case .create:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case let .dmList(workspaceID):
            return "/workspaces/\(workspaceID)/dms"
        case let .unreadCount(workspaceID, roomID, _):
            return "/workspaces/\(workspaceID)/dms/\(roomID)/unreads"
        case let .create(workspaceID, _):
            return "/workspaces/\(workspaceID)/dms"
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
        case .create:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? "",
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.contentType.rawValue: Header.json.rawValue
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
        case .unreadCount, .create:
            return parameters?.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        default:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case let .create(_, query):
            return try? encoder.encode(query)
        default:
            return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        return nil
    }
}
