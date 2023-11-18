//
//  NavigationService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

class NavigationService: ObservableObject {
    @Published var view: AppViews = .groups
    // UserDefaults.standard.data(forKey: "currentGroup") != nil ? .schedule : .groups
}

enum AppViews {
    case groups, schedule
}
