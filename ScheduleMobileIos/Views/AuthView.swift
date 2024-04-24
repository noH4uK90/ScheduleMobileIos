//
//  AuthView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/24/24.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var navigationService: NavigationService
    @State private var login: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack {
            inputs
            buttons
        }
        .padding()
    }

    var inputs: some View {
        VStack {
            TextField("Логин...", text: $login)
                .textFieldStyle(.roundedBorder)
            TextField("Пароль...", text: $login)
                .textFieldStyle(.roundedBorder)
        }
    }

    var buttons: some View {
        VStack(alignment: .leading) {
            Button {
                navigationService.isAuthenticated = true
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

#Preview {
    AuthView()
}
