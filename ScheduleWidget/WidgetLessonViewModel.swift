//
//  WidgetLessonViewModel.swift
//  ScheduleWidgetExtension
//
//  Created by Иван Спирин on 5/17/24.
//

import Foundation

extension WidgetLessonView {
    @MainActor class ViewModel: ObservableObject {
        @Published var timeStart: String = ""
        @Published var timeEnd: String = ""
        @Published var discipline: String = ""
        @Published var firstTeacher: String = ""
        @Published var secondTeacher: String = ""
        @Published var firstCabinet: String = ""
        @Published var secondCabinet: String = ""

        @Published var isChanged: Bool = false
        @Published var isOneTeacher: Bool = true
        @Published var isOneCabinet: Bool = true

        private var lesson: Lesson
        private var date: String
        private var lessonChange: LessonChange?

        init(lesson: Lesson, date: String) {
            self.lesson = lesson
            self.date = date
            updateLessonDetails()
        }

        private func updateLessonDetails() {
            timeStart = Date().convertTime(lesson.timeStart ?? "12:00")
            timeEnd = Date().convertTime(lesson.timeEnd ?? "12:00")
            discipline = lesson.discipline?.name.name ?? ""

            updateTeachersAndCabinets(from: lesson.lessonTeacherClassrooms)

            if let lessonChange = lesson.lessonChanges.first(where: { $0.date == date }) {
                isChanged = true

                timeStart = Date().convertTime(lessonChange.timeStart)
                timeEnd = Date().convertTime(lessonChange.timeEnd)
                discipline = lessonChange.discipline.name.name

                updateTeachersAndCabinets(from: lessonChange.lessonTeacherClassrooms)
            }
        }

        private func updateTeachersAndCabinets(from teacherClassrooms: [TeacherClassroom]) {
            isOneTeacher = teacherClassrooms.count <= 1
            isOneCabinet = teacherClassrooms.count <= 1

            if let first = teacherClassrooms.first {
                firstTeacher = getShortName(from: first.teacher)
                firstCabinet = first.classroom.cabinet
            }

            if let last = teacherClassrooms.last, teacherClassrooms.count > 1 {
                secondTeacher = getShortName(from: last.teacher)
                secondCabinet = last.classroom.cabinet
            }
        }

        private func getShortName(from teacher: Teacher) -> String {
            let nameInitial = teacher.name.first.map { "\($0)." } ?? ""
            let middleNameInitial = teacher.middleName?.first.map { "\($0)." } ?? ""
            return "\(teacher.surname) \(nameInitial)\(middleNameInitial)"
        }
    }
}
