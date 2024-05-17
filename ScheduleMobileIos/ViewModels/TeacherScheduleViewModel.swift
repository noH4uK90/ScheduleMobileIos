//
//  TeacherScheduleViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import Foundation
import Combine

extension TeacherScheduleView {
    @MainActor class ViewModel: ObservableObject {
        @Published var selected: Int = Date().dayNumberOfWeek()
        @Published var lessons: [Lesson] = []
        @Published var currentDate: String = ""

        @Inject private var teacherNetworkService: TeacherNetworkProtocol
        private var bag = Set<AnyCancellable>()

        private var teacher: Teacher

        init(teacher: Teacher) {
            self.teacher = teacher

            $selected
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] value in
                        self?.currentDate = Date().dateForDayOfWeek(day: value)
                        self?.getLessons()
                    }
                )
                .store(in: &bag)
        }

        private func getLessons() {
            Task {
                try teacherNetworkService.getTeacherLessons(teacherId: teacher.id, date: currentDate)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.lessons = value
                                .filter({ $0.discipline != nil })
                                .sorted(by: { Date().compareTime($0.timeStart ?? "", $1.timeStart ?? "")})
                        }
                    )
                    .store(in: &bag)
            }
        }
    }
}
