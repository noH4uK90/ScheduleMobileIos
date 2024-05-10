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
        @Inject private var teacherNetworkService: TeacherNetworkProtocol
        private var currentTimetables: [CurrentTimetable] = []
        private var bag = Set<AnyCancellable>()

        init(group: GroupModel?) {
            setupAccountNotification()
            setupGroupNotification()

            let effectiveGroup = group ?? userDefaultService.getGroup()

            if let group = effectiveGroup {
                getCurrentTimetables(groupId: group.id)
            }

            $selected
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] value in
                        self?.getLessons(selectedDay: value)
                    }
                )
                .store(in: &bag)
        }

        private func getLessons(selectedDay: Int) {
            getLessonsForGroup(selectedDay: selectedDay)
            getLessonsForTeacher(selectedDay: selectedDay)
        }
    }
}

// MARK: Group lesson extesion
extension ScheduleView.ViewModel {
    private func getLessonsForGroup(selectedDay: Int) {
        currentTimetables.forEach { current in
            if let day = current.daysAndDate.first(where: { $0.key.tValue.id == selectedDay }) {
                if let timetable = day.items.first {
                    lessons = timetable.lessons.filter { $0.discipline != nil }
                }
            }
        }
    }
}

// MARK: Teacher lesson extension
extension ScheduleView.ViewModel {
    private func getLessonsForTeacher(selectedDay: Int) {
        if let account = userDefaultService.getAccount() {
            if account.role.name == Roles.teacher.rawValue {
                getTeacherByAccount(id: account.id) { teacher in
                    self.currentDate = Date().dateForDayOfWeek(day: selectedDay)
                    self.getTeacherLessons(teacherId: teacher.id, date: self.currentDate)
                }
            }
        }
    }

    private func getTeacherByAccount(id: Int, completion: @escaping (Teacher) -> Void) {
        Task {
            try teacherNetworkService.getTeacherByAccount(id: id)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { value in
                        completion(value)
                    }
                )
                .store(in: &bag)
        }
    }
}

// MARK: Timetable extension
extension ScheduleView.ViewModel {
    private func getCurrentTimetables(groupId: Int) {
        Task {
            try timetableNetworkService.getCurrentTimeTable(groupId: groupId)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { completion in print(completion) },
                    receiveValue: { [weak self] value in
                        self?.currentTimetables = value.items
                    }
                )
                .store(in: &bag)
        }
    }

    private func getTeacherLessons(teacherId: Int, date: String) {
        Task {
            try teacherNetworkService.getTeacherLessons(teacherId: teacherId, date: date)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] value in
                        self?.currentTimetables = []
                        self?.lessons = value.filter { $0.discipline != nil }
                    }
                )
                .store(in: &bag)
        }
    }
}

// MARK: Notification
extension ScheduleView.ViewModel {
    private func setupAccountNotification() {
        NotificationCenter.default.publisher(for: .accountUpdated)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    if let account = self?.userDefaultService.account {
                        if account.role.name == Roles.teacher.rawValue {
                            self?.getLessonsForTeacher(selectedDay: self!.selected)
                        }
                    }
                    self?.getLessons(
                        selectedDay: self?.selected ?? Date().dayNumberOfWeek())
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
                    if let group = self?.userDefaultService.group {
                        self?.getCurrentTimetables(groupId: group.id)
                    }
                    self?.getLessons(
                        selectedDay: self?.selected ?? Date().dayNumberOfWeek())
                }
            )
            .store(in: &bag)
    }
}
