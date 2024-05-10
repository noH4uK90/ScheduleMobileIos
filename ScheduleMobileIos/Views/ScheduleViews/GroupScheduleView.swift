//
//  GroupScheduleView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import SwiftUI

struct GroupScheduleView: View {

    @State var group: GroupModel

    var body: some View {
        Content(group: group)
    }

    struct Content: View {
        @StateObject private var viewModel: ViewModel

        init(group: GroupModel) {
            _viewModel = StateObject(wrappedValue: ViewModel(group: group))
        }

        var body: some View {
            VStack {
                DayPicker(selection: $viewModel.selected)
                ScheduleView(lessons: $viewModel.lessons, currentDate: $viewModel.currentDate)
            }
        }
    }
}
