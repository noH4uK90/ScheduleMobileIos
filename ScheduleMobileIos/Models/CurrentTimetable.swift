//
//  CurrentTimetable.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct CurrentTimetable: Codable {
    let groups: [Group]
    let groupName: String
    let dates: [Grouped<DateModel, Timetable>]
}
