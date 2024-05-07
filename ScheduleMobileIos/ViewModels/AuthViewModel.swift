//
//  AuthViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/7/24.
//

import Foundation
import Combine

extension AuthView {
    @MainActor class ViewModel: ObservableObject {
        @Published var login: String = ""
        @Published var password: String = ""

        @Inject private var accountNetworkService: AccountNetworkProtocol
        @Inject private var studentNetworkService: StudentNetworkProtocol
        @Inject private var userDefaultsService: UserDefaultsProtocol
        private var navigationService: NavigationService
        private var secureSettings = SecureSettings()
        private var bag = Set<AnyCancellable>()

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
        }

        func logIn() {
            Task {
                try accountNetworkService
                    .login(login: login, password: password)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            switch completion {
                            case .finished:
                                self?.navigationService.isAuthenticated = true
                            case .failure(let failure):
                                print(failure)
                            }
                        },
                        receiveValue: { [weak self] value in
                            self?.setUpDefaults(value)
                        }
                    )
                    .store(in: &bag)
            }
        }

        private func setUpDefaults(_ value: AuthorizationResponse) {
            self.secureSettings.accessToken = value.accessToken
            self.secureSettings.refreshToken = value.refreshToken
            self.secureSettings.account = SecureStorage.Credentials(
                login: value.account.login,
                password: value.account.passwordHash)

            self.userDefaultsService.setAccount(account: value.account.toAccount())
            if value.account.role.name == Roles.student.rawValue {
                getStudentGroup(id: value.account.id) { group in
                    if let group = group {
                        self.userDefaultsService.setGroup(group: group)
                    }
                }
            }
        }

        private func getStudentGroup(id: Int, completion: @escaping (Group?) -> Void) {
            Task {
                try studentNetworkService.getStudentByAccount(id: id)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { completion in print(completion) },
                        receiveValue: { value in
                            completion(value.group)
                        }
                    )
                    .store(in: &bag)
            }
        }
    }
}
