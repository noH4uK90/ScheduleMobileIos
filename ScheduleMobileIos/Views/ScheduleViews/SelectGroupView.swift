//
//  ContentView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

struct SelectGroupView: View {

    //@EnvironmentObject var navigationService: NavigationService

    var body: some View {
        Content(/*navigationService: navigationService*/)
    }

    struct Content: View {

        @StateObject var viewModel: ViewModel

        init(/*navigationService: NavigationService*/) {
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
//            VStack {
                List {
                    ForEach(viewModel.groups, id: \.id) { group in
                        NavigationLink(group.name) {
                            NewScheduleView(groupId: group.id)
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchGroups()
                }
                .searchable(text: $viewModel.search, prompt: "Группа")
//                picker
//                groups
//                Spacer()
//            }
//            .padding(.horizontal, 15)
        }

//        var picker: some View {
//            Picker("",
//                   selection: $viewModel.selectedCourse) {
//                ForEach(Range(1...5), id: \.self) { course in
//                    Text("\(course) курс").tag(course)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal, 24)
//        }

//        var groups: some View {
//            ScrollView {
//                ForEach(viewModel.groups, id: \.key) { specialityGroups in
//                    GroupsView(specialityGroups: specialityGroups)
//                }
//            }
//            .padding(.horizontal, 24)
//        }
    }
}

#Preview {
    SelectGroupView()
        .environmentObject(NavigationService())
}
