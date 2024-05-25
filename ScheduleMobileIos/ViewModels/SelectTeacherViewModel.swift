//
//  SelectTeacherViewModel.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 5/11/24.
//

import Foundation
import Combine

extension SelectTeacherView {
    @MainActor class ViewModel: ObservableObject {
        @Published var teachers: [TeacherFullName] = []
        @Published var search: String = ""

        @Inject private var teacherNetworkService: TeacherNetworkProtocol
        private var bag = Set<AnyCancellable>()

        init() {
            $search
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] _ in
                        self?.getTeachers()
                    }
                )
                .store(in: &bag)
        }

        func getTeachers() {
            Task {
                try teacherNetworkService.getTeachers(search: self.search, page: 1)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.teachers = value
                        }
                    )
                    .store(in: &bag)
            }
        }

//        func loadMore() {
//            Task {
//                guard let data = dataTeachers else {
//                    return
//                }
//
//                if !isHasMore {
//                    return
//                }
//
//                let nextPage = data.pageNumber + 1
//
//                try teacherNetworkService.getTeachers(search: self.search, page: nextPage)
//                    .receive(on: RunLoop.main)
//                    .sink(
//                        receiveCompletion: { _ in },
//                        receiveValue: { [weak self] value in
//                            self?.teachers = value
//                            self?.isHasMore = self?.hasMore() ?? true
//                        }
//                    )
//                    .store(in: &bag)
//            }
//        }
//
//        func hasMore() -> Bool {
//            guard let data = dataTeachers else {
//                return true
//            }
//
//            return data.pageNumber < data.totalPages
//        }

        func getShortName(from teacher: Teacher) -> String {
            let nameInitial = teacher.name.first.map { "\($0)." } ?? ""
            let middleNameInitial = teacher.middleName?.first.map { "\($0)." } ?? ""
            return "\(teacher.surname) \(nameInitial)\(middleNameInitial)"
        }
    }
}
