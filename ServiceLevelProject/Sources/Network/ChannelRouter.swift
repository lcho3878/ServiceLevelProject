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
}

extension ChannelRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .myChannelList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .myChannelList(workspaceID):
            return "/workspaces/\(workspaceID)/my-channels"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .myChannelList:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? ""
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .myChannelList:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .myChannelList:
            return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        default: return nil
        }
    }
}
