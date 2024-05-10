//
//  ChangePasswordViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import Foundation
import Combine

extension ChangePasswordView {
    @MainActor class ViewModel: ObservableObject {
        @Published var password: String = ""
        @Published var newPassword: String = ""
        @Published var confirmPassword: String = ""

        @Published var showingAlert: Bool = false
        @Published var alertMessage: String = ""
        var action: () -> Void = {}

        private var secureSettings = SecureSettings()
        @Inject private var accountNetworkService: AccountNetworkProtocol
        @Inject private var userDefaults: UserDefaultsProtocol
        private var bag = Set<AnyCancellable>()

        func change(dismiss: @escaping () -> Void) {
            Task {
                if newPassword != confirmPassword {
                    self.alertMessage = "Пароли не совпадают"
                    self.action = { self.showingAlert = false }
                    self.showingAlert = true
                } else if newPassword.count < 8 {
                    self.alertMessage = "Минимальная длина пароля '8'"
                    self.action = { self.showingAlert = false }
                    self.showingAlert = true
                } else {
                    if let account = userDefaults.getAccount() {
                        try accountNetworkService
                            .changePassword(accountId: account.id, password: password, newPassword: newPassword)
                            .receive(on: RunLoop.main)
                            .sink(
                                receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        self.alertMessage = "Пароль успешно изменен"
                                        self.action = dismiss
                                        self.secureSettings.account?.password = self.password
                                        self.showingAlert = true
                                    case .failure(let failure):
                                        if let apiError = failure as? ApiError {
                                            self.alertMessage = apiError.error
                                            self.action = { self.showingAlert = false }
                                            self.showingAlert = true
                                        } else {
                                            self.alertMessage = failure.localizedDescription
                                            self.action = { self.showingAlert = false }
                                            self.showingAlert = true
                                        }
                                    }
                                },
                                receiveValue: { _ in }
                            )
                            .store(in: &bag)
                    }
                }
            }
        }
    }
}
