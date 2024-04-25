//
//  ScheduleMobileIosApp.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

@main
struct ScheduleMobileIosApp: App {
    @StateObject var navigationService: NavigationService = NavigationService()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(navigationService)
        }
    }
}
