//
//  CurrentTimetable.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct CurrentTimetable: Codable {
    let group: Group
    let daysAndDate: [Grouped<RecordValue<DayModel, String>, Timetable>]
}
