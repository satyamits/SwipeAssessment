//
//  DataModel.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//

import Foundation

private struct UserDefaultConfigKey {
    static let isUserOnboarded = "IsUserOnboarded"
}

class DataModel {
    static let shared = DataModel()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    @UserDefault(UserDefaultConfigKey.isUserOnboarded, false)
    public var isPremiumUser: Bool
    
}

@propertyWrapper
public struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    init(_ key: String, _ defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}
extension UserDefault where T: ExpressibleByNilLiteral {
    init(_ key: String) {
        self.init(key, nil)
    }
}
