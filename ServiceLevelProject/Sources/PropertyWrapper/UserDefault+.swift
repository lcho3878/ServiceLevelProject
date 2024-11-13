//
//  UserDefault+.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/13/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?
    let storage: UserDefaults = UserDefaults.standard
    var wrappedValue: T? {
        get {
            guard let wrappedValue = storage.object(forKey: key) as? T else { return defaultValue }
            return wrappedValue
        }
        set { storage.set(newValue, forKey: key) }
    }
}
