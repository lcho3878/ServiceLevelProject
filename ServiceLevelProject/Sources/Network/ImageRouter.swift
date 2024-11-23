//
//  ImageRouter.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/23/24.
//

import Foundation
import Alamofire

@frozen enum ImageRouter {
    case image(image: String)
}

extension ImageRouter: TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .image:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .image(let image):
            return image
        }

    }
    
    var header: [String : String] {
        switch self {
        case .image:
            return [
                Header.accept.rawValue: Header.image.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? ""
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
    
    var multipartFormData: Alamofire.MultipartFormData? {
        return nil
    }
}
