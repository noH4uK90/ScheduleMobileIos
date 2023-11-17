//
//  NavigationService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

class NavigationService: ObservableObject {
    @Published var view: AppViews = UserDefaults.standard.string(forKey: "CurrentGroup") != nil ? .schedule : .groups
}

enum AppViews {
    case groups, schedule
}
