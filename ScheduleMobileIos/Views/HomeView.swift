//
//  Home.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 3/28/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigationService: NavigationService
    @State private var activeTab: Tab = .schedule
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    @State private var screenSize = UIScreen.main.bounds.size
    @State private var safeSize: EdgeInsets = EdgeInsets()
    @StateObject private var viewModel = ViewModel()
    @Inject private var userDefaults: UserDefaultsProtocol
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geomerty in
                TabView(selection: $activeTab) {
                    NavigationStack {
                        ScheduleNavigationView()
                            .navigationTitle(Tab.schedule.title)
                            .environmentObject(navigationService)
                    }
                    .setUpTab(.schedule)
                    if let account = viewModel.account, account.role.name != Roles.employee.rawValue {
                        NavigationStack {
                            switch account.role.name {
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
                        .setUpTab(.mySchedule)
                    }
                    if navigationService.isAuthenticated {
                        NavigationStack {
                            AccountView()
                                .navigationTitle(Tab.account.title)
                                //.navigationBarTitleDisplayMode(.inline)
                                .environmentObject(navigationService)
                        }
                        .setUpTab(.account)
                    } else {
                        NavigationStack {
                            AuthView()
                                .navigationTitle("Авторизация")
                                .environmentObject(navigationService)
                        }
                        .setUpTab(.account)
                    }
                }
                .onAppear {
                    self.safeSize = geomerty.safeAreaInsets
                    if let account = viewModel.account, account.role.name != Roles.employee.rawValue {
                        self.activeTab = .mySchedule
                    }
                }
                .onOpenURL { url in
                    if let tab = url.tabIdentifier {
                        self.activeTab = tab
                    }
                }

                customTabBar(account: viewModel.account)
                    .position(x: screenSize.width / 2, y: screenSize.height - safeSize.bottom - safeSize.top - 25)
            }
        }
    }

    @ViewBuilder
    func customTabBar(account: Account?) -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab

                VStack(spacing: 0) {
                    Image(systemName: tab.rawValue)
                        .font(.title)
                        .symbolEffect(.bounce.down.byLayer, value: animatedTab.isAnimating)

                    Text(tab.title)
                        .font(.caption)
                        .textScale(.default)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        activeTab = tab
                        animatedTab.isAnimating = true
                    }, completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    })
                }
                .isHidden(tab.title == "Мое расписание" && (account == nil || account?.role.name == Roles.employee.rawValue), remove: true)
            }
        }
        .background(.bar)
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationService())
}
