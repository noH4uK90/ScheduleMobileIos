//
//  GroupViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation
import Combine

extension GroupView {
    @MainActor class ViewModel: ObservableObject {
        @Published var groups: PagedList<Group>?
        @Published var searchText = ""

        private var bag = Set<AnyCancellable>()
        private var navigationService: NavigationService

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
            $searchText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { value in
                        self.fetchGroups(search: value)
                    }
                )
                .store(in: &bag)
        }

        func fetchGroups(search: String) {
            Task {
                try NetworkService.shared.getGroups(search: search)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { value in
                            self.groups = value
                        }
                    )
                    .store(in: &bag)
            }
        }

        func selectGroup(group: Group) {
            GroupDefaultsService().selectGroup(group: group)
            navigationService.view = .schedule
        }
    }
}
