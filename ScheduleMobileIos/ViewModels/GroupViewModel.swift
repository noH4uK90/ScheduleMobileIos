//
//  GroupViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation
import Combine

extension SelectGroupView {
    @MainActor class ViewModel: ObservableObject {
        @Published var groups: [GroupModel] = [] // [Grouped<Speciality, GroupModel>]()
//        @Published var selectedCourse = 1
        @Published var search: String = ""

        private var bag = Set<AnyCancellable>()
        @Inject private var groupNetworkService: GroupNetworkProtocol

        init() {
//            $selectedCourse
//                .sink(
//                    receiveValue: { [weak self] value in
//                        self?.fetchGroups(course: value)
//                    }
//                )
//                .store(in: &bag)
            fetchGroups()
            $search
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] _ in
                        self?.groups = []
                        self?.fetchGroups()
                    }
                )
                .store(in: &bag)
        }

        func fetchGroups() {
            Task {
                try groupNetworkService.getGroups(search: search)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.groups = value
                        }
                    )
                    .store(in: &bag)
            }
        }

//        func fetchGroups(course: Int) {
//            Task {
//                try groupNetworkService.getCourseGroups(id: course)
//                    .receive(on: RunLoop.main)
//                    .sink(
//                        receiveCompletion: { _ in },
//                        receiveValue: { [weak self] value in
//                            self?.groups = value
//                        }
//                    )
//                    .store(in: &bag)
//            }
//        }
    }
}
