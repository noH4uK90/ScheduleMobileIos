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
    func getGroup() -> Group?
}

class GroupDefaultsService: GroupDefaultsProtocol {
    var currentGroup: Group?
    func selectGroup(group: Group) {
        Task {
            let data = try JSONEncoder().encode(group)
            UserDefaults.standard.setValue(data, forKey: "currentGroup")

        }
    }
    func getGroup() -> Group? {
        let data = UserDefaults.standard.data(forKey: "currentGroup")
        guard var group = try? JSONDecoder().decode(Group?.self, from: data ?? Data()) else {
            return nil
        }
        currentGroup = group
        return group
    }
}
