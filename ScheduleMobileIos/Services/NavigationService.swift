//
//  NavigationService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation
import Combine

class NavigationService: ObservableObject {
    @Published var view: AppViews = .auth
    @Published var isAuthenticated = !(SecureSettings().accessToken?.isEmpty ?? true)
    @Published var account: Account?
    @Published var group: GroupModel?

    @Inject private var userDefaultsService: UserDefaultsProtocol
    private var bag = Set<AnyCancellable>()

    init() {
        self.account = userDefaultsService.getAccount()

        setupAccountNotification()
        setupGroupNotification()
    }

    private func setupAccountNotification() {
        NotificationCenter.default.publisher(for: .accountUpdated)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    self?.account = self?.userDefaultsService.getAccount()
                }
            )
            .store(in: &bag)
    }

    private func setupGroupNotification() {
        NotificationCenter.default.publisher(for: .groupUpdated)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    self?.group = self?.userDefaultsService.getGroup()
                }
            )
            .store(in: &bag)
    }
}

enum AppViews {
    case auth, home
}
