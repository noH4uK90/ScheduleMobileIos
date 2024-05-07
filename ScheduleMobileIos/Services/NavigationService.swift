//
//  NavigationService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation

class NavigationService: ObservableObject {
    @Published var view: AppViews = .auth
    @Published var isAuthenticated = !(SecureSettings().accessToken?.isEmpty ?? true)
    // UserDefaults.standard.data(forKey: "currentGroup") != nil ? .schedule : .groups
}

enum AppViews {
    case auth, home
}
