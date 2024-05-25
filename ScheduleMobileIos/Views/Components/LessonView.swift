//
//  LessonView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/2/24.
//

import SwiftUI

struct LessonView: View {
    @Binding var lesson: Lesson
//    @Binding var date: String

    var body: some View {
        Content(lesson: lesson)
    }

    struct Content: View {
//        @StateObject var viewModel: ViewModel
        var lesson: Lesson

        init(lesson: Lesson) {
            self.lesson = lesson
//            _viewModel = StateObject(wrappedValue: ViewModel(lesson: lesson))
        }

        var body: some View {
            HStack(alignment: .top) {
                createTime()
                VStack(alignment: .leading) {
                    title
                    teacher
                    Spacer()
                    cabinet
                }

                Spacer()
            }
            .frame(maxHeight: 80)
            .padding(.horizontal, 5)
        }

        var title: some View {
            HStack {
                Text(lesson.discipline.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.5)
                Spacer()
//                if viewModel.isChanged {
//                    Text("Изм.")
//                        .padding(.horizontal, 3)
//                        .cornerRadius(0)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 3)
//                                .stroke(.red.gradient, lineWidth: 1)
//                        }
//                }
            }
        }

        var teacher: some View {
            HStack(spacing: 0) {
                Image(systemName: "person.fill")
                    .padding(.trailing, 5)
                    .unredacted()
                Text(lesson.teacher?.fullName ?? "")
                //Text(viewModel.firstTeacher + "\(viewModel.isOneTeacher ? "" : " \(viewModel.secondTeacher)")")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.5)
        }

        var cabinet: some View {
            HStack {
                Text(lesson.classroom?.cabinet ?? "")
                //Text(viewModel.firstCabinet)
                    .cabinetTextStyle()

//                if !viewModel.isOneCabinet {
//                    Text(viewModel.secondCabinet)
//                        .cabinetTextStyle()
//                }
            }
            .font(.callout)
            .foregroundStyle(.blue)
            .minimumScaleFactor(0.5)
        }

        @ViewBuilder
        func createTime() -> some View {
            VStack(alignment: .center) {
                Text(lesson.timeStart)
                Spacer()
                Text(lesson.timeEnd)
            }
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxHeight: 80)
            .padding(.horizontal, 3)
            .padding(.vertical, 3)
            .background(.blue.gradient)
            .foregroundStyle(.white)
            .cornerRadius(7)
            .minimumScaleFactor(0.5)

            Divider()
                .frame(height: 85)
                .overlay(.foreground)
        }
    }
}

//  #Preview {
//      LessonView()
//  }
