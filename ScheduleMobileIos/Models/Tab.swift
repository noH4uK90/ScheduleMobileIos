//
//  Tab.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 3/28/24.
//

import Foundation

enum Tab: String, CaseIterable {
    case schedule = "character.book.closed"
    case account = "person.crop.circle"

    var title: String {
        switch self {
        case .schedule:
            return "Расписание"
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
