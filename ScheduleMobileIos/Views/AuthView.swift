//
//  AuthView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/24/24.
//

import SwiftUI

struct AuthView: View {
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
            VStack {
                inputs
                buttons
            }
            .padding()
        }

        var inputs: some View {
            VStack {
                TextField("Логин...", text: $viewModel.login)
                    .textFieldStyle(.roundedBorder)
                TextField("Пароль...", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
            }
        }

        var buttons: some View {
            VStack(alignment: .leading) {
                Button {
                    viewModel.logIn()
                } label: {
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .padding(.top)
                NavigationLink("Забыли пароль?") {
                    RestorePasswordView()
                }
                .padding(.horizontal)
            }
        }
    }
}

//#Preview {
//    AuthView()
//}
