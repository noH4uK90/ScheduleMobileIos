//
//  GroupDefaultsService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation

protocol GroupDefaultsProtocol {
    var currentGroup: Group? { get set }

    func selectGroup(group: Group)
    mutating func getGroup() throws
}

struct GroupDefaultsService: GroupDefaultsProtocol {
    var currentGroup: Group?
    func selectGroup(group: Group) {
        Task {
            let data = try JSONEncoder().encode(group)
            UserDefaults.standard.setValue(data, forKey: "currentGroup")

        }
    }
    mutating func getGroup() throws {
        let data = UserDefaults.standard.data(forKey: "currentGroup")
        let group = try JSONDecoder().decode(Group.self, from: data ?? Data())
        currentGroup = group
    }
}
