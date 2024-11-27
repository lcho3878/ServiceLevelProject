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
    case chattingList(workspaceID: String, roomID: String, after: String)
    case sendChatting(workspaceID: String, roomID: String, query: ChattingQuery)
}

extension DMRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .dmList, .unreadCount, .chattingList:
            return .get
        case .sendChatting:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case let .dmList(workspaceID):
            return "/workspaces/\(workspaceID)/dms"
        case let .unreadCount(workspaceID, roomID, _):
            return "/workspaces/\(workspaceID)/dms/\(roomID)/unreads"
        case let .chattingList(workspaceID, roomID, _):
            return "/workspaces/\(workspaceID)/dms/\(roomID)/chats"
        case let .sendChatting(workspaceID, roomID, _):
            return "/workspaces/\(workspaceID)/dms/\(roomID)/chats"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .dmList, .unreadCount, .chattingList, .sendChatting:
             [
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
        case let .chattingList(_, _, after):
            return [
                "cursor_date": after
            ]
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .unreadCount, .chattingList:
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
        switch self {
        case let .sendChatting(_, _, query):
            let multipart = MultipartFormData()
            let content = query.content.data(using: .utf8) ?? Data()
            multipart.append(content, withName: "content")
            if query.files.isEmpty { return multipart }
            for (i, file) in query.files.enumerated() {
                guard let file else { continue }
                multipart.append(file, withName: "files", fileName: "\(i).jpeg", mimeType: "image/jpeg")
            }
            return multipart
        default: return nil
        }
    }
}
