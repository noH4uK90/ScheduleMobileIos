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
    let discipline: Discipline
    let teacher: TeacherFullName?
    let classroom: Classroom?
    let lessonType: LessonType
    let subLesson: SubLesson?
    let timeStart: String
    let timeEnd: String
}
