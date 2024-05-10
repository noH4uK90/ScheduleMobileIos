//
//  Timetable.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Timetable: Identifiable, Codable, Hashable {
    let id: Int
    let group: GroupModel
    let created: String
    let ended: String?
    let day: DayModel
    let weekType: WeekType
    let lessons: [Lesson]
}
