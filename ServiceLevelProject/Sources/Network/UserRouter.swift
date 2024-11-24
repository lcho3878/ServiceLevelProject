//
//  UserRouter.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case validationEmail(query: ValidationEmailQuery)
    case signUp(query: SignUpQuery)
    case login(query: LoginQuery)
    case refreshToken
    case profile
    case editProfileImage(query: ProfileImageQuery)
}

extension UserRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .validationEmail, .login:
            return .post
        case .refreshToken, .profile:
            return .get
        case .editProfileImage:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        case .validationEmail:
            return "/users/validation/email"
        case .login:
            return "/users/login"
        case .refreshToken:
            return "/auth/refresh"
        case .profile:
            return "/users/me"
        case .editProfileImage:
            return "/users/me/image"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp, .validationEmail, .login:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.contentType.rawValue: Header.json.rawValue
            ]
            
        case.refreshToken:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.refreshToken.rawValue: UserDefaultManager.refreshToken ?? "",
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? "",
                Header.sesacKey.rawValue: Key.sesacKey,
            ]
        case .profile:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.authorization.rawValue: UserDefaultManager.accessToken ?? "",
                Header.sesacKey.rawValue: Key.sesacKey,
            ]
        case .editProfileImage:
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
        default: return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
        /*
         // 쿼리스트링 있는 경우 예시)
         
         case .있는경우:
         return parameters?.map {
         URLQueryItem(name: $0.key, value: $0.value)
         }
         default:
         return nil
         */
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case.validationEmail(let query):
            return try? encoder.encode(query)
        case .signUp(let query):
            return try? encoder.encode(query)
        case .login(let query):
            return try? encoder.encode(query)
        default:
            return nil
        }
    }
    
    var multipartFormData: MultipartFormData? {
        let multipart = MultipartFormData()
        
        switch self {
        case let .editProfileImage(query):
            appendCommonFields(for: query)
            return multipart
        default: return nil
        }
        
        func appendCommonFields(for query: ProfileImageQuery) {
            multipart.append(query.image, withName: "image", fileName: "Image.jpeg", mimeType: "image/jpeg")
        }
    }
}
