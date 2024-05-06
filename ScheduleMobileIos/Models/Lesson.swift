//
//  Lesson.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Lesson: Identifiable, Codable, Hashable {
    let id: Int
    let discipline: Discipline?
    let number: Int
    let subgroup: Int?
    let timetableId: Int
    let lessonChanges: [LessonChange]
    let timeStart: String?
    let timeEnd: String?
    let lessonTeacherClassrooms: [TeacherClassroom]
}
