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
        @EnvironmentObject var navigationService: NavigationService
        @StateObject var viewModel: ViewModel

        init() {
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
            VStack {
                dayPicker
                scheduleList
                    //.redacted(reason: isLoaded ? [] : .placeholder)
            }
        }

        var dayPicker: some View {
            Picker("Days",
                   selection: $viewModel.selected) {
                ForEach(viewModel.days.sorted(by: <), id: \.key) { _, day in
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
        .environmentObject(NavigationService())
}
