//
//  LessonChange.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation

struct LessonChange: Identifiable, Codable, Hashable {
    let id: Int
    let number: Int
    let subgroup: Int?
    let timeStart: String
    let timeEnd: String
    let lesson: Lesson
    let discipline: Discipline
    let date: Date
    let lessonTeacherClassrooms: [TeacherClassroom]
}
