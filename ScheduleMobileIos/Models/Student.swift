//
//  Student.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation

struct Student: Identifiable, Codable, Hashable {
    let id: Int
    let group: GroupModel
    let login: String
    let email: String
    let name: String
    let surname: String
    let middleName: String?
}
