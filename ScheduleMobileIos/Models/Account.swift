//
//  Account.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation

struct Account: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let passwordHash: String
    let name: Name
    let surname: Surname
    let middleName: MiddleName?
    let email: String
    let role: Role
    let isDeleted: Bool
}
