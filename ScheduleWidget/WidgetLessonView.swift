//
//  LessonView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/2/24.
//

import SwiftUI

struct WidgetLessonView: View {
//    @State var lesson: Lesson
//
//    var body: some View {
//        HStack(alignment: .top) {
//            createTime()
//            VStack(alignment: .leading) {
//                title
//                teacher
//                Spacer()
//                cabinet
//            }
//
//            Spacer()
//        }
//        .frame(maxHeight: 80)
//    }
//
//    var title: some View {
//        HStack {
//            Text("Математика")
//                .font(.title3)
//                .fontWeight(.semibold)
//                .minimumScaleFactor(0.5)
//            Spacer()
//            if true {
//                Text("Изм.")
//                    .padding(.horizontal, 3)
//                    .cornerRadius(0)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 3)
//                            .stroke(.red.gradient, lineWidth: 1)
//                    }
//            }
//        }
//    }
//
//    var teacher: some View {
//        HStack(spacing: 0) {
//            Image(systemName: "person.fill")
//                .padding(.trailing, 5)
//                .unredacted()
//            Text("Иванов И.И.")
//        }
//        .font(.footnote)
//        .foregroundStyle(.secondary)
//        .minimumScaleFactor(0.5)
//    }
//
//    var cabinet: some View {
//        HStack {
//            Text("400")
//                .cabinetTextStyle()
//
//            if false {
//                Text("400")
//                    .cabinetTextStyle()
//            }
//        }
//        .font(.callout)
//        .foregroundStyle(.blue)
//        .minimumScaleFactor(0.5)
//    }
//
//    @ViewBuilder
//    func createTime() -> some View {
//        VStack(alignment: .center) {
//            Text("8:30")
//            Spacer()
//            Text("10:10")
//        }
//        .font(.headline)
//        .fontWeight(.semibold)
//        .frame(maxHeight: 80)
//        .padding(.horizontal, 3)
//        .padding(.vertical, 3)
//        .background(.blue.gradient)
//        .foregroundStyle(.white)
//        .cornerRadius(7)
//        .minimumScaleFactor(0.5)
//
//        Divider()
//            .frame(height: 85)
//            .overlay(.foreground)
//    }
    var lesson: Lesson
    var date: String

    var body: some View {
        Content(lesson: lesson, date: date)
    }

    struct Content: View {
        @StateObject var viewModel: ViewModel

        init(lesson: Lesson, date: String) {
            _viewModel = StateObject(wrappedValue: ViewModel(lesson: lesson, date: date))
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
                Text(viewModel.discipline)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.5)            }
        }

        var teacher: some View {
            HStack(spacing: 0) {
                Image(systemName: "person.fill")
                    .padding(.trailing, 5)
                    .unredacted()
                Text(viewModel.firstTeacher + "\(viewModel.isOneTeacher ? "" : viewModel.secondTeacher)")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.5)
        }

        var cabinet: some View {
            HStack {
                Text(viewModel.firstCabinet)
                    .cabinetTextStyle()

                if !viewModel.isOneCabinet {
                    Text(viewModel.secondCabinet)
                        .cabinetTextStyle()
                }
            }
            .font(.callout)
            .foregroundStyle(.blue)
            .minimumScaleFactor(0.5)
        }

        @ViewBuilder
        func createTime() -> some View {
            VStack(alignment: .center) {
                Text(viewModel.timeStart)
                Spacer()
                Text(viewModel.timeEnd)
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

//#Preview {
//    WidgetLessonView()
//}
