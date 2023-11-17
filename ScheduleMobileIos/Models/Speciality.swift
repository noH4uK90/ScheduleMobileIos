//
//  Speciality.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

struct Speciality: Identifiable, Codable, Hashable {
    let id: Int
    let code: String
    let name: String
    let maxTermId: Int
    let isDeleted: Bool
}
