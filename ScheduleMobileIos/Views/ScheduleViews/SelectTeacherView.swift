//
//  SelectTeacherView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/11/24.
//

import SwiftUI

struct SelectTeacherView: View {
    var body: some View {
        Content()
    }

    struct Content: View {

        @StateObject private var viewModel: ViewModel

        init() {
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
            List {
                ForEach(viewModel.teachers) { teacher in
                    NavigationLink(teacher.fullName) {
                        TeacherScheduleView(teacher: teacher)
                            .navigationTitle("Расписание преподавателя")
                    }
                }
            }
            .refreshable {
                viewModel.getTeachers()
            }
            .searchable(text: $viewModel.search, prompt: "Преподаватель")
        }
    }
}

#Preview {
    SelectTeacherView()
}
