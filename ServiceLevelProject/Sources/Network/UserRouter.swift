//
//  UserRouter.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case validationEmail(query: ValidationEmail)
    case signUp(query: SignUp)
}

extension UserRouter : TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .validationEmail:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        case .validationEmail:
            return "/users/validation/email"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp, .validationEmail:
            return [
                Header.accept.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.sesacKey,
                Header.contentType.rawValue: Header.json.rawValue
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .signUp, .validationEmail: // 파라미터 있는 경우 이 둘은 'default: return nil'로 빼주시면 됩니다 :)
            return nil
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
        }
    }
    
    var multipartFormData: MultipartFormData? {
        /*
         multipartFormData를 사용하는 Router에서 구현해주시면 됩니다.
         사용하지 않는 경우 기본적으로 nil return 해주세요.
         */
        switch self {
        default: return nil
        }
    }
}
