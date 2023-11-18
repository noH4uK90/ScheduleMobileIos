//
//  Teacher.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Teacher: Identifiable, Codable, Hashable  {
    let id: Int
    let name: String
    let surname: String
    let middleName: String
    let email: String
    let shortFio: String
    let isDeleted: Bool
}
