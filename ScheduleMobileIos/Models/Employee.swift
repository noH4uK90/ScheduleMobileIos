//
//  Employee.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation

struct Employee: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let email: String
    let name: String
    let surname: String
    let middleName: String?
    let premissions: [Permission]
}
