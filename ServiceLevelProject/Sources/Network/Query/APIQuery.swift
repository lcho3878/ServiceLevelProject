//
//  APIQuery.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import UIKit

//MARK: ValidationEmail
struct ValidationEmail: Encodable {
    let email: String
}

//MARK: SignUp
struct SignUp: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String
    let deviceToken: String
}

struct WorkspaceCreateQuery: Encodable {
    let name: String
    let description: String?
    let image: Data?
}
