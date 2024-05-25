//
//  NewScheduleView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/19/24.
//

import SwiftUI
import Combine

struct NewScheduleView: View {
    @State var groupId: Int

    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false

    @StateObject private var viewModel: ViewModel

    init(groupId: Int) {
        self.groupId = groupId
        _viewModel = StateObject(wrappedValue: ViewModel(groupId: groupId))
    }

    var body: some View {
        DateWheel(currentDate: $viewModel.currentDate, weekSlider: $weekSlider, currentWeekIndex: $currentWeekIndex, createWeek: $createWeek)
        List {
            //if var lessons = viewModel.timetables.first?.lessons, lessons.count != 0 {
                ForEach($viewModel.lessons, id: \.id) { $lesson in
                    LessonView(lesson: $lesson)
                }
//            } else {
//                Text("Пар на сегодня нет")
//            }
        }
    }
}

extension NewScheduleView {
    @MainActor class ViewModel: ObservableObject {
        @Published var timetables: [Timetable] = []
        @Published var currentDate: Date = .init()
        @Published var lessons: [Lesson] = []

        private var groupId: Int
        @Inject private var timetableNetworkService: TimetableNetworkProtocol
        private var bag = Set<AnyCancellable>()

        init(groupId: Int) {
            self.groupId = groupId
            $currentDate
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] _ in
                        self?.getTimetables()
                    }
                )
                .store(in: &bag)
        }

        public func getTimetables() {
            Task {
                try timetableNetworkService.getGroupTimetable(groupId: groupId, date: currentDate)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.lessons = value.first?.lessons ?? []
                        }
                    )
                    .store(in: &bag)
            }
        }
    }
}

//#Preview {
//    NewScheduleView()
//}
