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
        @Published var groups = [Grouped<Speciality, GroupModel>]()
        @Published var selectedCourse = 1

        private var bag = Set<AnyCancellable>()
        @Inject private var groupNetworkService: GroupNetworkProtocol

        init() {
            $selectedCourse
                .sink(
                    receiveValue: { [weak self] value in
                        self?.fetchGroups(course: value)
                    }
                )
                .store(in: &bag)
        }

        func fetchGroups(course: Int) {
            Task {
                try groupNetworkService.getCourseGroups(id: course)
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
    }
}
