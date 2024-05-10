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
                    NavigationLink(viewModel.getShortName(from: teacher)) {
                        TeacherScheduleView(teacher: teacher)
                            .navigationTitle("Расписание преподавателя")
                    }
                }
                if viewModel.isHasMore {
                    ProgressView()
                        .onAppear {
                            viewModel.loadMore()
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
