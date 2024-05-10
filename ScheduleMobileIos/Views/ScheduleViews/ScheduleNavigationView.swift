//
//  ScheduleNavigation.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/10/24.
//

import SwiftUI

struct ScheduleNavigationView: View {
    @EnvironmentObject var navigationService: NavigationService

    var body: some View {
        Content(navigationService: navigationService)
    }

    struct Content: View {
        @StateObject private var viewModel: ViewModel
        private var navigationService: NavigationService

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
            List {
                if let account = viewModel.account, account.role.name != Roles.employee.rawValue {
                    NavigationLink(value: account.role.name) {
                        Text("Мое расписание")
                    }
                    .navigationDestination(for: String.self) { role in
                        switch role {
                        case Roles.student.rawValue:
                            if let group = viewModel.group {
                                GroupScheduleView(group: group)
                                    .navigationTitle("Мое расписание")
                            }
                        case Roles.teacher.rawValue:
                            if let teacher = viewModel.teacher {
                                TeacherScheduleView(teacher: teacher)
                                    .navigationTitle("Мое расписание")
                            }
                        default:
                            EmptyView()
                        }
                    }
                }
                NavigationLink("Расписание группы") {
                    SelectGroupView()
                        .navigationTitle("Группы")
                        .environmentObject(navigationService)
                }
                NavigationLink("Расписание преподавателя") {
                    SelectTeacherView()
                        .navigationTitle("Преподаватели")
                }
            }
        }
    }
}
