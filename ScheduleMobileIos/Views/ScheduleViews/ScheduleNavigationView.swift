//
//  ScheduleNavigation.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import SwiftUI

struct ScheduleNavigationView: View {
//    @EnvironmentObject var navigationService: NavigationService

    var body: some View {
        Content(/*navigationService: navigationService*/)
    }

    struct Content: View {
        
//        @StateObject private var viewModel: ViewModel
//        private var navigationService: NavigationService
//
//        init(navigationService: NavigationService) {
//            self.navigationService = navigationService
//            _viewModel = StateObject(wrappedValue: ViewModel())
//        }
        @State private var selected: Int = 1
        @State private var searched: String = ""
        private var tabs = [1: "Группа", 2: "Преподаватель"]

        var body: some View {
//            List {
//                NavigationLink("Расписание группы") {
//                    SelectGroupView()
//                        .navigationTitle("Группы")
//                        .environmentObject(navigationService)
//                }
//                NavigationLink("Расписание преподавателя") {
//                    SelectTeacherView()
//                        .navigationTitle("Преподаватели")
//                }
//            }
            NavigationStack {
                VStack {
                    List {
                        if selected == 1 {
                            Text("ИСПП-01")
                            Text("ИСПП-11")
                            Text("ИСПП-05")
                            Text("ИСПП-21")
                            Text("ИСПП-35")
                        } else {
                            Text("Преподаватель 1")
                            Text("Преподаватель 2")
                            Text("Преподаватель 3")
                            Text("Преподаватель 4")
                            Text("Преподаватель 5")
                            Text("Преподаватель 6")
                        }
                    }
                    .searchable(text: $searched)
                }
                .background(Color(UIColor.systemGroupedBackground))
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("Schedule", selection: $selected) {
                            ForEach(tabs.sorted(by: <), id: \.key) { index, tab in
                                Text(tab).tag(index)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ScheduleNavigationView()
}
