//
//  TimetableView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/18/23.
//

import SwiftUI

struct TimetableView: View {
    @State var lessons: [Lesson] = []
    var body: some View {
        VStack {
            Text("ИСПП-01")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            List {
                ForEach(lessons, id: \.id) { lesson in
                    LessonView(lesson: lesson)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
        }
    }
}

#Preview {
    TimetableView()
}
