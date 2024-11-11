//
//  ErrorCode.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation

enum ErrorCode: Error {
    /// 200
    case success
    /// 400
    case clientError
    /// 500
    case serverError
}
