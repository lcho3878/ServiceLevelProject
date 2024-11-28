//
//  String+.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/28/24.
//

import Foundation

extension String {
    static let dateForamatter = DateFormatter()
    
    func isoStringToDate() -> Date? {
        let formatter = String.dateForamatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: self) else { return nil }
        return date
    }
    
    func formatting(format: String) -> String {
        guard let date = self.isoStringToDate() else { return "포맷 변환 불가"}
        let formatter = String.dateForamatter
        formatter.dateFormat = format
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}
