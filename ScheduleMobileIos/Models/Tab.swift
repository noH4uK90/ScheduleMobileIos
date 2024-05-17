//
//  Tab.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 3/28/24.
//

import Foundation

enum Tab: String, CaseIterable {
    case schedule = "book.closed"
    case mySchedule = "character.book.closed"
    case account = "person.crop.circle"

    var title: String {
        switch self {
        case .schedule:
            return "Расписание"
        case .mySchedule:
            return "Мое расписание"
        case .account:
            return "Профиль"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

extension URL {
    var tabIdentifier: Tab? {
        switch self.host {
        case "schedule":
            return .schedule
        case "mySchedule":
            return .mySchedule
        case "account":
            return .account
        default:
            return nil
        }
    }
}
