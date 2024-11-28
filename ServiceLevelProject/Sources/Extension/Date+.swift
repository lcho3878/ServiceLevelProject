//
//  Date+.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/28/24.
//

import Foundation

extension Date {
    static let isoFormmater = ISO8601DateFormatter()
    func asISOSTring() -> String {
        Date.isoFormmater.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return Self.isoFormmater.string(from: self)
    }
}
