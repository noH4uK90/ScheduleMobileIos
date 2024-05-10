//
//  GroupSheduleViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import Foundation
import Combine

extension GroupScheduleView {
    @MainActor class ViewModel: ObservableObject {
        @Published var selected: Int = Date().dayNumberOfWeek()
        @Published var lessons: [Lesson] = []
        @Published var currentDate: String = ""

        @Inject private var timetablesNetworkService: TimetableNetworkProtocol
        private var currentTimetables: [CurrentTimetable] = []
        private var bag = Set<AnyCancellable>()

        private var group: GroupModel

        init(group: GroupModel) {
            self.group = group
            self.getTimetables()

            $selected
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] value in
                        self?.currentTimetables.forEach { current in
                            if let day = current.daysAndDate.first(where: { $0.key.tValue.id == value }) {
                                if let timetable = day.items.first {
                                    self?.currentDate = Date().dateForDayOfWeek(day: value)
                                    self?.lessons = timetable.lessons.filter { $0.discipline != nil }
                                }
                            }
                        }
                    }
                )
                .store(in: &bag)
        }

        private func getTimetables() {
            Task {
                try timetablesNetworkService.getCurrentTimeTable(groupId: group.id)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.currentTimetables = value.items
                        }
                    )
                    .store(in: &bag)
            }
        }
    }
}
