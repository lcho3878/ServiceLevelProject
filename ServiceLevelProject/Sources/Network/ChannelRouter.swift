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
    case addChannel(workspaceID: String, query: ChannelQuery)
    case deleteChannel(workspaceID: String, channelID: String)
    case exitChannel(workspaceID: String, channelID: String)
    case fetchChannelChatHistory(cursorDate: String, workspaceID: String, ChannelID: String)
    case editChannel(workspaceID: String, channelID: String, query: ChannelQuery)
    case channelDetails(workspaceID: String, channelID: String)
    case changeAdmin(workspaceID: String, channelID: String, query: OwnerQuery)
}

extension ChannelRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .channelList, .myChannelList, .unreadCount, .exitChannel, .fetchChannelChatHistory, .channelDetails:
            return .get
        case .addChannel:
            return .post
        case .deleteChannel:
            return .delete
        case .editChannel, .changeAdmin:
            return .put
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
        case let .exitChannel(workspaceID, channelID):
            return "/workspaces/\(workspaceID)/channels/\(channelID)/exit"
        case let .fetchChannelChatHistory(_, workspaceID, ChannelID):
            return "/workspaces/\(workspaceID)/channels/\(ChannelID)/chats"
        case let .editChannel(workspaceID, channelID, _):
            return "/workspaces/\(workspaceID)/channels/\(channelID)"
        case let .channelDetails(workspaceID, channelID):
            return "/workspaces/\(workspaceID)/channels/\(channelID)"
        case let .changeAdmin(workspaceID, channelID, _):
            return "/workspaces/\(workspaceID)/channels/\(channelID)/transfer/ownership"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .channelList, .myChannelList, .unreadCount, .deleteChannel, .exitChannel, .fetchChannelChatHistory, .channelDetails:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? ""
            ]
        case .addChannel, .editChannel:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? "",
                Header.contentType.rawValue: Header.mutipart.rawValue
            ]
        case .changeAdmin:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? "",
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
        case let .fetchChannelChatHistory(cursorDate, _, _):
            return [
                "cursor_date": cursorDate
            ]
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .unreadCount, .fetchChannelChatHistory:
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
        case let .changeAdmin(_, _, query):
            return try? encoder.encode(query)
        default: return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        let multipart = MultipartFormData()
        switch self {
        case let .addChannel(_, query):
            appendCommonFields(for: query)
            return multipart
        case let .editChannel(_, _, query):
            appendCommonFields(for: query)
            return multipart
        default:
            return nil
        }
        
        func appendCommonFields(for query: ChannelQuery) {
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
