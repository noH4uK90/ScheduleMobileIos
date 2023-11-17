//
//  ScheduleMobileIosApp.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

@main
struct ScheduleMobileIosApp: App {
    let navigationService = NavigationService()

    var body: some Scene {
        WindowGroup {
            switch navigationService.view {
            case .groups:
                GroupView()
            case .schedule:
                ScheduleView()
            }
        }
    }
}
