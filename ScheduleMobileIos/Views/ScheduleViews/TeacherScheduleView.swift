//
//  TeacherScheduleView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import SwiftUI

struct TeacherScheduleView: View {

    @State var teacher: Teacher

    var body: some View {
        Content(teacher: teacher)
    }

    struct Content: View {
        @StateObject private var viewModel: ViewModel

        init(teacher: Teacher) {
            _viewModel = StateObject(wrappedValue: ViewModel(teacher: teacher))
        }

        var body: some View {
            VStack {
                DayPicker(selection: $viewModel.selected)
                ScheduleView(lessons: $viewModel.lessons, currentDate: $viewModel.currentDate)
            }
        }
    }
}
