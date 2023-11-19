//
//  SheduleViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import Foundation
import Combine

extension ScheduleView {
    @MainActor class ViewModel: ObservableObject {
        private var navigationService: NavigationService
        @Inject private var groupService: GroupDefaultsProtocol
        @Inject private var networkService: NetworkService

        @Published var timeTable: PagedList<CurrentTimetable>?
        @Published var groupData: Group?

        private var bag = Set<AnyCancellable>()

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
            groupData = groupService.getGroup()
            fetchTimetable()
        }

        func fetchTimetable() {
            Task {
                guard let group = groupData else {
                    return
                }

                try networkService.getCurrentTimeTable(groupId: group.id)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { value in
                            self.timeTable = value
                        }
                    )
                    .store(in: &bag)
            }
        }
    }
}
