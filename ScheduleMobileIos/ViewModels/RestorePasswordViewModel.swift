//
//  RestorePasswordViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/9/24.
//

import Foundation
import SwiftUI
import Combine

extension RestorePasswordView {
    @MainActor class ViewModel: ObservableObject {
        @Published var email: String = ""
        @Published var showingAlert: Bool = false
        @Published var alertMessage: String = ""
        var alertAction: () -> Void = {}

        @Inject private var accountNetworkService: AccountNetworkProtocol
        private var bag = Set<AnyCancellable>()

        func restorePassword(dismiss: @escaping () -> Void) {
            Task {
                try accountNetworkService.restorePassword(email: email)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            print(completion)
                            switch completion {
                            case .finished:
                                self?.alertMessage = "Новый пароль выслан на Вашу электронную почту"
                                self?.alertAction = dismiss
                                self?.showingAlert = true
                            case .failure(let failure):
                                self?.alertMessage = failure.localizedDescription
                                self?.alertAction = { self?.showingAlert = false }
                                self?.showingAlert = true
                            }
                        },
                        receiveValue: { _ in }
                    )
                    .store(in: &bag)
            }
        }
    }
}
