//
//  Time.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Time: Identifiable, Codable, Hashable {
    let id: Int
    let start: String
    let end: String
    let duration: Int
    let lessonNumber: Int
    let type: TimeType
    let isDeleted: Bool
}
