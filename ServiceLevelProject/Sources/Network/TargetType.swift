//
//  TargetType.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String : String] { get }
    var parameters: [String : String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        let urlString = url.appendingPathComponent(path).absoluteString
        guard var urlComponents = URLComponents(string: urlString) else { return URLRequest(url: url) }
        urlComponents.queryItems = queryItems
        
        guard let requestURL = urlComponents.url else { return URLRequest(url: url) }
        var request = try URLRequest(url: requestURL, method: method)
        request.allHTTPHeaderFields = header
        request.httpBody = body
        return request
    }
}
