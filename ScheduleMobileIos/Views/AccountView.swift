//
//  AccountView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 3/28/24.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        Content()
    }

    struct Content: View {
        @EnvironmentObject var navigationService: NavigationService
        @StateObject private var viewModel: ViewModel

        init() {
            _viewModel = StateObject(wrappedValue: ViewModel())
        }

        var body: some View {
            Text("Account")
        }
    }
}

#Preview {
    AccountView()
}
