//
//  Term.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

struct Term: Identifiable, Codable, Hashable {
    let id: Int
    let courseTerm: Int
    let course: Course
}
