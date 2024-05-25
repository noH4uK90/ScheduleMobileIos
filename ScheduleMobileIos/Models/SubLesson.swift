//
//  SubLesson.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/26/24.
//

import Foundation

struct SubLesson: Identifiable, Codable, Hashable {
    let id: Int
    let classroom: Classroom?
    let discipline: Discipline
    let teacher: TeacherFullName?
    let type: LessonType
}
