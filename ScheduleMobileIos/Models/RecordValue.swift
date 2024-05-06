//
//  RecordValue.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/6/24.
//

import Foundation

struct RecordValue<T: Codable, K: Codable>: Codable {
    let tValue: T
    let kValue: K
}
