//
//  AccountView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 3/28/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var navigationService: NavigationService

    var body: some View {
        Content(navigationService: navigationService)
    }

    struct Content: View {
        @StateObject private var viewModel: ViewModel

        init(navigationService: NavigationService) {
            _viewModel = StateObject(wrappedValue: ViewModel(navigationService: navigationService))
        }

        var body: some View {
            NavigationStack {
                Form {
                    account
                    settings
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
