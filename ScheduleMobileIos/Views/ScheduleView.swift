//
//  ScheduleView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

struct ScheduleView: View {

    var body: some View {
        Content()
    }

    struct Content: View {

        @StateObject var viewModel: ViewModel
        private var days = Date().daysOfWeek()
        @State private var selected: Int
        @State private var isLoaded = false

        init() {
            _viewModel = StateObject(wrappedValue: ViewModel())
            selected = Date().dayNumberOfWeek()
        }

        var body: some View {
            VStack {
                dayPicker
                scheduleList
                    .redacted(reason: isLoaded ? [] : .placeholder)
            }
        }

        var dayPicker: some View {
            Picker("Days",
                   selection: $selected) {
                ForEach(days.sorted(by: <), id: \.key) { _, day in
                    Text("\(day)")
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
        }

        var scheduleList: some View {
            List {
                ForEach(Range(0...2)) { _ in
                    LessonView()
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.inset)
        }
    }
}

#Preview {
    ScheduleView()
}
