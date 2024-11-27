//
//  CoinShopRouter.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/27/24.
//

import Foundation
import Alamofire

enum CoinShopRouter {
    case itemList
}

extension CoinShopRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .itemList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .itemList:
            return "/store/item/list"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .itemList:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? "",
                Header.sesacKey.rawValue: Key.sesacKey
            ]
        }
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    var multipartFormData: MultipartFormData? {
        return nil
    }
}
