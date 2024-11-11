//
//  APIQuery.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation

struct ValidationEmail: Encodable {
    let email: String
}

struct SignUp: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String
    let deviceToken: String
}
