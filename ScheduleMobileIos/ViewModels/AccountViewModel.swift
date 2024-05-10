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
        @Published var group: GroupModel?

        @Inject private var accountNetworkService: AccountNetworkProtocol
        @Inject private var userDefaultsService: UserDefaultsProtocol
        private var navigationService: NavigationService
        private var bag = Set<AnyCancellable>()

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
            self.account = userDefaultsService.getAccount()
            self.group = userDefaultsService.getGroup()
            setupAccountNotification()
            setupGroupNotification()
        }

        func logOut() {
            Task {
                try accountNetworkService.logout()
                userDefaultsService.clear()
                navigationService.isAuthenticated = false
                SecureSettings().clear()
            }
        }

        private func setupAccountNotification() {
            NotificationCenter.default.publisher(for: .accountUpdated)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] _ in
                        self?.account = self?.userDefaultsService.getAccount()                    }
                )
                .store(in: &bag)
        }

        private func setupGroupNotification() {
            NotificationCenter.default.publisher(for: .groupUpdated)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] _ in
                        self?.group = self?.userDefaultsService.getGroup()                    }
                )
                .store(in: &bag)
        }
    }
}
