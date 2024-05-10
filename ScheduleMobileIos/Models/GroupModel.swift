//
//  Group.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

struct GroupModel: Identifiable, Codable, Hashable {
    let id: Int
    let number: String
    let name: String
    let enrollmentYear: Int
    let isAfterEleven: Bool
    let term: Term
    let speciality: Speciality
    let isDeleted: Bool
}
