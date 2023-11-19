//
//  TimeType.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct TimeType: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let isDeleted: Bool
}
