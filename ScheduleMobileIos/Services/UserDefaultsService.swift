//
//  GroupDefaultsService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

protocol UserDefaultsProtocol {
    var account: Account? { get set }
    var group: GroupModel? { get set }

    func setAccount(account: Account?)
    func setGroup(group: GroupModel?)

    func getAccount() -> Account?
    func getGroup() -> GroupModel?

    func clear()
}

class UserDefaultsService: UserDefaultsProtocol {
    var account: Account?
    var group: GroupModel?

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
    func setGroup(group: GroupModel?) {
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
    func getGroup() -> GroupModel? {
        let data = UserDefaults.standard.data(forKey: "group")
        guard let response = try? JSONDecoder().decode(GroupModel?.self, from: data ?? Data()) else {
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
