//
//  SecurePropertyWrappers.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/21/24.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct Credentials: DynamicProperty {
    private let label: String
    private let storage = SecureStorage()

    public init(_ label: String) {
        self.label = label
    }

    public var wrappedValue: SecureStorage.Credentials? {
        get { storage.getCredentials(with: label) }
        nonmutating set {
            if let newValue = newValue {
                storage.updateCredentials(newValue, with: label)
            } else {
                storage.deleteCredentials(with: label)
            }
        }
    }
}

@propertyWrapper
public struct Password: DynamicProperty {
    private let key: String
    private let storage = SecureStorage()

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: String? {
        get { storage.getPassword(for: key) }
        nonmutating set {
            if let newValue {
                storage.updatePassword(newValue, for: key)
            } else {
                storage.deletePassword(for: key)
            }
        }
    }
}
