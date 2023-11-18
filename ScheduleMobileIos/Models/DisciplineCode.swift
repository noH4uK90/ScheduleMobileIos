//
//  DisciplineCode.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct DisciplineCode: Identifiable, Codable, Hashable {
    let id: Int
    let code: String
    let isDeleted: Bool
}
