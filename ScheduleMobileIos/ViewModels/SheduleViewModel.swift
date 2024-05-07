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
        @Published var days = Date().daysOfWeek()
        @Published var selected: Int = Date().dayNumberOfWeek()
        @Published private var isLoaded = false
        @Published var lessons: [Lesson] = []
        @Published var currentDate: String = ""

        @Inject private var timetableNetworkService: TimetableNetworkProtocol
        @Inject private var userDefaultService: UserDefaultsProtocol
        private var timetables: [CurrentTimetable] = []
        private var bag = Set<AnyCancellable>()

        init(group: Group?) {

            let effectiveGroup = group ?? userDefaultService.group

            if let group = effectiveGroup {
                getCurrentTimetable(groupId: userDefaultService.group?.id ?? 1)

                $selected
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveValue: { [weak self] value in
                            self?.updateLessonsForSelectedDay(value)
                        }
                    )
                    .store(in: &bag)
            }
        }

        private func updateLessonsForSelectedDay(_ selectedDay: Int) {
            timetables.forEach { currentTimetable in
                if let day = currentTimetable.daysAndDate.first(where: { $0.key.tValue.id == selectedDay }) {
                    self.currentDate = day.key.kValue
                    self.lessons = day.items[0].lessons.filter { lesson in lesson.discipline != nil }
                }
            }
        }

        private func getCurrentTimetable(groupId: Int) {
            Task {
                try timetableNetworkService.getCurrentTimeTable(groupId: groupId)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { completion in print(completion) },
                        receiveValue: { [weak self] value in
                            self?.timetables = value.items
                        }
                    )
                    .store(in: &bag)
            }
        }
    }
}
