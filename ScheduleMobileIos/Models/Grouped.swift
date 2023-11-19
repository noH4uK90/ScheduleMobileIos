//
//  Grouped.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

struct Grouped<TKey: Codable, TItem: Codable>: Codable {
    let key: TKey
    let items: [TItem]
}
