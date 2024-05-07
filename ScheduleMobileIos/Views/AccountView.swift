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
            VStack {
                Text("Account")
            }
            .toolbar {
                Button("Выход") {
                    viewModel.logOut()
                }
            }
        }
    }
}

//#Preview {
//    AccountView()
//}
