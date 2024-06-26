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
        @Published var groups = [Group]()
        @Published var searchText = ""
        @Published var isHasMore = true

        private var bag = Set<AnyCancellable>()
        private var navigationService: NavigationService
        private var dataGroups: PagedList<Group>?
        @Inject private var groupService: GroupDefaultsProtocol
        @Inject private var networkService: NetworkProtocol

        init(navigationService: NavigationService) {
            self.navigationService = navigationService
            $searchText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { value in
                        self.dataGroups = nil
                        self.fetchGroups(search: value)
                    }
                )
                .store(in: &bag)
        }

        func fetchGroups(search: String) {
            Task {
                try networkService.getGroups(search: search, page: 1)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.dataGroups = value
                            self?.groups = value.items
                        }
                    )
                    .store(in: &bag)
                isHasMore = hasMore()
            }
        }

        func loadMore() {
            Task {
                guard let data = dataGroups else {
                    return
                }

                if !isHasMore {
                    return
                }

                let nextPage = data.pageNumber + 1

                try networkService.getGroups(search: searchText, page: nextPage)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.dataGroups = value
                            self?.groups.append(contentsOf: value.items)
                        }
                    )
                    .store(in: &bag)
                isHasMore = hasMore()
            }
        }

        func selectGroup(group: Group) {
            groupService.selectGroup(group: group)
            navigationService.view = .schedule
        }

        func hasMore() -> Bool {
            guard let data = dataGroups else {
                return true
            }

            return data.pageNumber < data.totalPages
        }
    }
}
