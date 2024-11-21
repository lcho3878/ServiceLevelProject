//
//  ChannelRouter.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/18/24.
//

import Foundation
import Alamofire

enum ChannelRouter {
    case channelList(workspaceID: String)
    case myChannelList(workspaceID: String)
    case unreadCount(workspaceID: String, channelID: String, after: String)
    case addChannel(workspaceID: String, query: AddChannelQuery)
    case deleteChannel(workspaceID: String, channelID: String)
}

extension ChannelRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .channelList, .myChannelList, .unreadCount:
            return .get
        case .addChannel:
            return .post
        case .deleteChannel:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case let .channelList(workspaceID):
            return "/workspaces/\(workspaceID)/channels"
        case let .myChannelList(workspaceID):
            return "/workspaces/\(workspaceID)/my-channels"
        case let .unreadCount(workspaceID, channelID, _):
            return "/workspaces/\(workspaceID)/channels/\(channelID)/unreads"
        case let .addChannel(workspaceID, _):
            return "/workspaces/\(workspaceID)/channels"
        case let .deleteChannel(workspaceID, channelID):
            return "/workspaces/\(workspaceID)/channels/\(channelID)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .channelList, .myChannelList, .unreadCount, .deleteChannel:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? ""
            ]
        case .addChannel:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? "",
                Header.contentType.rawValue: Header.mutipart.rawValue
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
        switch self {
        default:
            return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        let multipart = MultipartFormData()
        switch self {
        case let .addChannel(_, query):
            appendCommonFields(for: query)
            return multipart
        default: 
            return nil
        }
        
        func appendCommonFields(for query: AddChannelQuery) {
            let nameData = query.name.data(using: .utf8) ?? Data()
            multipart.append(nameData, withName: "name")
            
            let description = query.description?.data(using: .utf8) ?? Data()
            multipart.append(description, withName: "description")
            
            if let image = query.image {
                multipart.append(image, withName: "image", fileName: "Image.png", mimeType: "image/png")
            }
        }
    }
}
