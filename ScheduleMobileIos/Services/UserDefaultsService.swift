//
//  GroupDefaultsService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

protocol UserDefaultsProtocol {
    var account: Account? { get set }
    var group: Group? { get set }

    func setAccount(account: Account?)
    func setGroup(group: Group?)

    func getAccount() -> Account?
    func getGroup() -> Group?

    func clear()
}

class UserDefaultsService: UserDefaultsProtocol {
    var account: Account?
    var group: Group?

    init() {
        account = getAccount()
        group = getGroup()
    }

    func setAccount(account: Account?) {
        Task {
            if let account = account {
                let data = try JSONEncoder().encode(account)
                UserDefaults.standard.setValue(data, forKey: "account")
            }
            self.account = getAccount()
            NotificationCenter.default.post(name: .accountUpdated, object: nil)
        }
    }
    func setGroup(group: Group?) {
        Task {
            if let group = group {
                let data = try JSONEncoder().encode(group)
                UserDefaults.standard.setValue(data, forKey: "group")
            }
            self.group = getGroup()
            NotificationCenter.default.post(name: .groupUpdated, object: nil)
        }
    }

    func getAccount() -> Account? {
        let data = UserDefaults.standard.data(forKey: "account")
        guard let response = try? JSONDecoder().decode(Account?.self, from: data ?? Data()) else {
            return nil
        }
        return response
    }
    func getGroup() -> Group? {
        let data = UserDefaults.standard.data(forKey: "group")
        guard let response = try? JSONDecoder().decode(Group?.self, from: data ?? Data()) else {
            return nil
        }
        return response
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "group")
    }
}

extension Notification.Name {
    static let accountUpdated = Notification.Name("accountUpdated")
    static let groupUpdated = Notification.Name("groupUpdated")
}