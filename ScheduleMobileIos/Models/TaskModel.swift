//
//  Task.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/18/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class TaskModel: Identifiable {
    var id: UUID
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool = false
    var tint: String

    init(id: UUID = .init(), taskTitle: String, creationDate: Date = .init(), isCompleted: Bool = false, tint: String) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
    }

    var tintColor: Color {
        return Color(hex: tint) ?? .red.opacity(0.3)
    }
}
