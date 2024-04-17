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

        init() {
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
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
