//
//  Account.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation

struct Account: Identifiable, Codable, Hashable {
    let id: Int
    let name: Name
    let surname: Surname
    let middleName: MiddleName?
    let email: String
    let role: Role
}

struct FullAccount: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let passwordHash: String
    let name: Name
    let surname: Surname
    let middleName: MiddleName?
    let email: String
    let role: Role
    let isDeleted: Bool

    func toAccount() -> Account {
        return Account(id: id, name: name, surname: surname, middleName: middleName, email: email, role: role)
    }
}

struct LoginCommand: Codable {
    let login: String
    let password: String
}

struct LogoutCommand: Codable {
    let accessToken: String
    let refreshToken: String
    var isAllDevices: Bool = true
}

struct RefreshCommand: Codable {
    let refreshToken: String
    let accessToken: String
}
