//
//  ContentView.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import SwiftUI

struct GroupView: View {

    @EnvironmentObject var navigationService: NavigationService

    var body: some View {
        Content(navigationService: navigationService)
    }

    struct Content: View {

        @StateObject var viewModel: ViewModel

        init(navigationService: NavigationService) {
            _viewModel = StateObject(wrappedValue: ViewModel(navigationService: navigationService))
        }

        var body: some View {
            NavigationStack {
                List {
                    ForEach(viewModel.groups?.items ?? []) { group in
                        Text("\(group.name), \(group.speciality.name)")
                            .onTapGesture {
                                viewModel.selectGroup(group: group)
                            }
                    }
                }
                .refreshable {
                    viewModel.fetchGroups(search: viewModel.searchText)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Группа...")
        }
    }
}

#Preview {
    GroupView()
}
