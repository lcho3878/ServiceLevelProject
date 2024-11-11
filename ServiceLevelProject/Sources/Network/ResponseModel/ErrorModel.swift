//
//  ErrorModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import Foundation

struct ErrorModel: Decodable, Error {
    let errorCode: String
}
