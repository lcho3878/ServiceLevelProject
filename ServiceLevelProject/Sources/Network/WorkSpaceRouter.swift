//
//  WorkSpaceRouter.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/13/24.
//

import Foundation
import Alamofire

enum WorkSpaceRouter {
    case list
    case create(query: WorkspaceCreateQuery)
}

extension WorkSpaceRouter: TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .create:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .list, .create:
            return "/workspaces"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .list:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: Key.accessToken
            ]
        case .create:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: Key.accessToken,
                Header.contentType.rawValue: Header.mutipart.rawValue
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .list, .create: // 파라미터 있는 경우 이 둘은 'default: return nil'로 빼주시면 됩니다 :)
            return nil
        }
    }
    
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .list, .create:
            return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        let multipart = MultipartFormData()
        switch self {
        case .create(let query):
            let name = query.name.data(using: .utf8) ?? Data()
            multipart.append(name, withName: "name")
            let description = query.description?.data(using: .utf8) ?? Data()
            multipart.append(description, withName: "description")
            if let image = query.image {
                multipart.append(image, withName: "image", fileName: "Image.png", mimeType: "image/png")
            }
            return multipart
        default: return nil
        }
    }
}
