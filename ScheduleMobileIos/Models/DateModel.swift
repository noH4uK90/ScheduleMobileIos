//
//  DateModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct DateModel: Identifiable, Codable, Hashable {
    let id: Int
    let isStudy: Bool
    let term: Int
    let value: String
    let day: Day
    let weeekType: WeekType
}
