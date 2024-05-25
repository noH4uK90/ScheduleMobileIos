//
//  AccountView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 3/28/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var navigationService: NavigationService
    @Binding var isTabBarHidden: Bool

    var body: some View {
        Content(navigationService: navigationService, isTabBarHidden: $isTabBarHidden)
    }

    struct Content: View {
        @StateObject private var viewModel: ViewModel
        @Binding var isTabBarHidden: Bool

        init(navigationService: NavigationService, isTabBarHidden: Binding<Bool>) {
            _isTabBarHidden = isTabBarHidden
            _viewModel = StateObject(wrappedValue: ViewModel(navigationService: navigationService))
        }

        var body: some View {
            NavigationStack {
                Form {
                    account
                    settings
                    study
                    logOutButton
                }
            }
        }

        var account: some View {
            VStack(alignment: .center) {
                Text("\(viewModel.account?.surname.value ?? "") \(viewModel.account?.name.value ?? "")")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("\(viewModel.account?.email ?? "")\(viewModel.group != nil ? " \u{2022} " : "")\(viewModel.group?.name ?? "")")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .listRowInsets(EdgeInsets())
            .background(Color(UIColor.systemGroupedBackground))
        }

        var settings: some View {
            Section {
                NavigationLink("Изменить пароль") {
                    ChangePasswordView()
                        .onAppear {
                            isTabBarHidden = true
                        }
                        .onDisappear {
                            isTabBarHidden = false
                        }
                }
            }
        }

        var study: some View {
            Section {
                NavigationLink("Задачи") {
                    TaskHomeView()
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(.hidden, for: .tabBar)
                        .onAppear {
                            withAnimation(.spring) {
                                isTabBarHidden = true
                            }
                        }
                        .onDisappear {
                            withAnimation(.spring) {
                                isTabBarHidden = false
                            }
                        }
                }
                NavigationLink("Домашнее задание") {
                    Text("Домашнее задание")
                }
                NavigationLink("Уведомления") {
                    Text("Уведомления")
                }
            }
        }

        var logOutButton: some View {
            Section {
                Button("Выход", role: .destructive) {
                    viewModel.logOut()
                }
            }
        }
    }
}
