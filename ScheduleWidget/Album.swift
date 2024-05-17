//
//  Album.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/17/24.
//

import Foundation

struct Album: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
}
