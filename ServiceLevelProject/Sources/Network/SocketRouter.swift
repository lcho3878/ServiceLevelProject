//
//  SocketRouter.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/25/24.
//

import Foundation

enum SocketRouter {
    case chatting(id: String)
    case dm(id: String)
}

extension SocketRouter {
    static var baseURL: URL? {
        return URL(string: Key.baseURL + "v1")
    }
    
    var namespace: String {
        switch self {
        case .chatting(let id):
            return "/ws-channel-\(id)"
        case .dm(let id):
            return "ws/-dm-\(id)"
        }
    }
}
