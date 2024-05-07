//
//  AccountViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 3/28/24.
//

import Foundation
import Combine

extension AccountView {
    @MainActor class ViewModel: ObservableObject {
        @Inject private var accountNetworkService: AccountNetworkProtocol
        @Inject private var userDefaults: UserDefaultsProtocol
        private var navigationService: NavigationService

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
        }

        func logOut() {
            Task {
                try accountNetworkService.logout()
                userDefaults.clear()
                navigationService.isAuthenticated = false
                SecureSettings().clear()
            }
        }
    }
}
