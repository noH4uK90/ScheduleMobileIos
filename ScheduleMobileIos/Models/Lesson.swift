//
//  Lesson.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Lesson: Identifiable, Codable, Hashable {
    let id: Int
    let number: Int
    let subgroup: Int?
    let timetableId: Int
    let isChanged: Bool
    let time: Time
    let discipline: Discipline
    let teacherClassrooms: [TeacherClassroom]
}
