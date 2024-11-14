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
    case edit(id: String, query: WorkspaceCreateQuery)
    case delete(id: String)
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
        case .edit:
            return .put
        case.delete:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .list, .create:
            return "/workspaces"
        case .edit(let id, _):
            return "/workspaces/\(id)"
        case .delete(let id):
            return "/workspaces/\(id)"
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
        case .create, .edit, .delete:
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
        default: return nil
        }
    }
    
    
    var queryItems: [URLQueryItem]? {
        switch self {
        default: return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        default: return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        let multipart = MultipartFormData()
        switch self {
        case .create(let query):
            appendCommonFields(for: query)
            return multipart
        case .edit(_, let query):
            appendCommonFields(for: query)
            return multipart
        default: return nil
        }
        
        func appendCommonFields(for query: WorkspaceCreateQuery) {
            if let name = query.name {
                let nameData = name.data(using: .utf8) ?? Data()
                multipart.append(nameData, withName: "name")
            }
            let description = query.description?.data(using: .utf8) ?? Data()
            multipart.append(description, withName: "description")
            if let image = query.image {
                multipart.append(image, withName: "image", fileName: "Image.png", mimeType: "image/png")
            }
        }
    }
}
