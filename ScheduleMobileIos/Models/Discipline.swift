//
//  Discipline.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Discipline: Identifiable, Codable, Hashable {
    let id: Int
    let name: DisciplineName
    let code: DisciplineCode
    let type: DisciplineType
    let term: Term
    let speciality: Speciality
    let totalHourse: Int
    let isDeleted: Bool
}
