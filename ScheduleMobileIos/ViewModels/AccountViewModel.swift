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
        @Published var account: Account?

        @Inject private var accountNetworkService: AccountNetworkProtocol
        @Inject private var userDefaultsService: UserDefaultsProtocol
        private var navigationService: NavigationService

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
            self.account = userDefaultsService.getAccount()
        }

        func logOut() {
            Task {
                try accountNetworkService.logout()
                userDefaultsService.clear()
                navigationService.isAuthenticated = false
                SecureSettings().clear()
            }
        }
    }
}
