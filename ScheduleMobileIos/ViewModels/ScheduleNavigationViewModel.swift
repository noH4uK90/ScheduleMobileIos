//
//  ScheduleNavigationViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import Foundation
import Combine

extension ScheduleNavigationView {
    @MainActor class ViewModel: ObservableObject {
        @Published var account: Account?
        @Published var group: GroupModel?
        @Published var teacher: Teacher?

        @Inject private var userDefaultsService: UserDefaultsProtocol
        @Inject private var teacherNetworkService: TeacherNetworkProtocol
        private var bag = Set<AnyCancellable>()

        init() {
            self.account = userDefaultsService.getAccount()
            self.group = userDefaultsService.getGroup()

            setupAccountNotification()
            setupGrouptNotification()

            if let account = self.account, account.role.name == Roles.teacher.rawValue {
                self.getTeacherByAccount()
            }
        }

        private func getTeacherByAccount() {
            Task {
                if let account = self.account {
                    try teacherNetworkService.getTeacherByAccount(id: account.id)
                        .receive(on: RunLoop.main)
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { [weak self] value in
                                self?.teacher = value
                            }
                        )
                        .store(in: &bag)
                }
            }
        }

        private func setupAccountNotification() {
            NotificationCenter.default.publisher(for: .accountUpdated)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] _ in
                        self?.account = self?.userDefaultsService.getAccount()
                        if let account = self?.account, account.role.name == Roles.teacher.rawValue {
                            self?.getTeacherByAccount()
                        }
                    }
                )
                .store(in: &bag)
        }


        private func setupGrouptNotification() {
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
}
