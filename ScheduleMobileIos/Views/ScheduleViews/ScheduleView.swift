//
//  ScheduleView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

struct ScheduleView: View {

    @Binding var lessons: [Lesson]
    @Binding var currentDate: String

    var body: some View {
        List {
            ForEach($lessons) { $lesson in
                LessonView(lesson: $lesson, date: $currentDate)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.inset)
    }
}
