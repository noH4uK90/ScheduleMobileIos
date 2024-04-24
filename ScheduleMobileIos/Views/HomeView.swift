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
    @State private var isAuthenticated = false
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                if navigationService.isAuthenticated {
                    NavigationStack {
                        ScheduleView()
                            .navigationTitle(Tab.schedule.title)
                            .environmentObject(navigationService)
                    }
                    .setUpTab(.schedule)

                    NavigationStack {
                        AccountView()
                            .navigationTitle(Tab.account.title)
                            .environmentObject(navigationService)
                    }
                    .setUpTab(.account)
                } else {
                    NavigationStack {
                        GroupView()
                            .navigationTitle("Группа")
                            .environmentObject(navigationService)
                    }
                    .setUpTab(.schedule)

                    NavigationStack {
                        AuthView()
                            .navigationTitle("Авторизация")
                            .environmentObject(navigationService)
                    }
                    .setUpTab(.account)
                }
            }

            customTabBar()
        }
    }

    @ViewBuilder
    func customTabBar() -> some View {
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
            }
        }
        .background(.bar)
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationService())
}
