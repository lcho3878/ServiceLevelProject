//
//  ChannelRouter.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/18/24.
//

import Foundation
import Alamofire

enum ChannelRouter {
    case myChannelList(workspaceID: String)
    case unreadCount(workspaceID: String, channelID: String, after: String)
}

extension ChannelRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .myChannelList, .unreadCount:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .myChannelList(workspaceID):
            return "/workspaces/\(workspaceID)/my-channels"
        case let .unreadCount(workspaceID, channelID, _):
            return "/workspaces/\(workspaceID)/channels/\(channelID)/unreads"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .myChannelList, .unreadCount:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? ""
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .unreadCount(_, _, let after):
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
        let encoder = JSONEncoder()
        switch self {
        case .myChannelList, .unreadCount:
            return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        default: return nil
        }
    }
}
