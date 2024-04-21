//
//  SecureStorageExtensions.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/21/24.
//

import Foundation

// MARK: Credentials extension
public extension SecureStorage {
    struct Credentials {
        public var login: String
        public var password: String

        public init(login: String, password: String) {
            self.login = login
            self.password = password
        }
    }

    func addCredentials(_ credentials: Credentials, with label: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrLabel] = label
        query[kSecAttrAccount] = credentials.login
        query[kSecValueData] = credentials.password.data(using: .utf8)

        do {
            try addItem(query: query)
        } catch {
            return
        }
    }

    func updateCredentials(_ credentials: Credentials, with label: String) {
        deleteCredentials(with: label)
        addCredentials(credentials, with: label)
    }

    func getCredentials(with label: String) -> Credentials? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrLabel] = label

        var result: [CFString: Any]?

        do {
            result = try findItem(query: query)
        } catch {
            return nil
        }

        if let account = result?[kSecAttrAccount] as? String,
           let data = result?[kSecValueData] as? Data,
           let password = String(data: data, encoding: .utf8) {
            return Credentials(login: account, password: password)
        } else {
            return nil
        }
    }

    func deleteCredentials(with label: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrLabel] = label

        do {
            try deleteItem(query: query)
        } catch {
            return
        }
    }
}

// MARK: Password extension
public extension SecureStorage {
    func addPassword(_ password: String, for account: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account
        query[kSecValueData] = password.data(using: .utf8)

        do {
            try addItem(query: query)
        } catch {
            return
        }
    }

    func updatePassword(_ password: String, for account: String) {
        if getPassword(for: account) == nil {
            addPassword(password, for: account)
            return
        }

        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account

        var attributesToUpdate: [CFString: Any] = [:]
        attributesToUpdate[kSecValueData] = password.data(using: .utf8)

        do {
            try updateItem(query: query, attributesToUpdate: attributesToUpdate)
        } catch {
            return
        }
    }

    func getPassword(for account: String) -> String? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account

        var result: [CFString: Any]?

        do {
            result = try findItem(query: query)
        } catch {
            return nil
        }

        if let data = result?[kSecValueData] as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    func deletePassword(for account: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account

        do {
            try deleteItem(query: query)
        } catch {
            return
        }
    }
}
