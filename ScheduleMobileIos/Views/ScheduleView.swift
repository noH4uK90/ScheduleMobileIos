//
//  ScheduleView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

struct ScheduleView: View {

    @EnvironmentObject var navigationService: NavigationService

    var body: some View {
        Content(navigationService: navigationService)
    }

    struct Content: View {

        @StateObject var viewModel: ViewModel

        init(navigationService: NavigationService) {
            let viewModel = ViewModel(navigationService: navigationService)
            _viewModel = StateObject(wrappedValue: viewModel)
        }

        var body: some View {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    ScheduleView()
}
