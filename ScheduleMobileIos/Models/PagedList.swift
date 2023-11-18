//
//  PagedList.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

struct PagedList<T: Codable>: Codable {
    let pageSize: Int
    let pageNumber: Int
    let totalCount: Int
    let totalPages: Int
    let items: [T]
}
