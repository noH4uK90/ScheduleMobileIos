//
//  Timetable.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Timetable: Identifiable, Codable, Hashable {
    let id: Int
    let date: Date
    let group: GroupModel
    let day: DayModel
    let lessons: [Lesson]
}
