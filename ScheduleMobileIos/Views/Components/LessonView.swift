//
//  Timetable.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import SwiftUI

struct LessonView: View {
    @State var lesson: Lesson
    var body: some View {
        VStack {
            createText(lesson.discipline.name.name)
            HStack {
                createText(lesson.teacherClassrooms.first?.teacher.name ?? "")
                createText(lesson.teacherClassrooms.first?.classroom?.cabinet ?? "")
                    .frame(maxWidth: 120)
            }
            HStack {
                createText(lesson.teacherClassrooms.last?.teacher.name ?? "")
                createText(lesson.teacherClassrooms.last?.classroom?.cabinet ?? "")
                    .frame(maxWidth: 120)
            }
            createText("\(lesson.time.start) - \(lesson.time.end)")
        }
        .padding(.vertical, 3)
    }

    private func createText(_ content: String) -> some View {
        return Text(content)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 3)
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 7, height: 7))
                    .stroke(.blue, lineWidth: 2)
            )
            .lineLimit(0)
            .padding(0)
    }
}

//  #Preview {
//    LessonView()
//  }
