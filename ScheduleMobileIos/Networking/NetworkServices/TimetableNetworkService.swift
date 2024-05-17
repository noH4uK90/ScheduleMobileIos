//
//  TimetableNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation
import Combine

protocol TimetableNetworkProtocol {
    func getCurrentTimeTable(groupId: Int) throws -> AnyPublisher<PagedList<CurrentTimetable>, Error>

    func getLessons(groupId: Int, day: Int) async throws -> [Lesson]
}

final class TimetableNetworkService: TimetableNetworkProtocol {
    @Inject private var network: DataTransferProtocol
    private var bag = Set<AnyCancellable>()

    func getCurrentTimeTable(groupId: Int) throws -> AnyPublisher<PagedList<CurrentTimetable>, any Error> {
        guard let url = TimetableEndpoints.currentTimetable(groupId).absoluteURL else {
            throw APIError.invalidResponse
        }
        return try network.fetch(url, PagedList<CurrentTimetable>.self)
    }

    func getLessons(groupId: Int, day: Int) async throws -> [Lesson] {
        print("Fetching lessons for groupId: \(groupId), day: \(day)")
        return try await withCheckedThrowingContinuation { continuation in
                Task {
                    try getCurrentTimeTable(groupId: groupId)
                        .receive(on: DispatchQueue.main)
                        .sink(
                            receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    continuation.resume(throwing: error)
                                }
                            },
                            receiveValue: { value in
                                var lessons: [Lesson] = []
                                value.items.forEach { current in
                                    if let dayItem = current.daysAndDate.first(where: { $0.key.tValue.id == day }) {
                                        if let timetable = dayItem.items.first {
                                            lessons.append(contentsOf: timetable.lessons)
                                        }
                                    }
                                }
                                print("Fetched lessons: \(lessons)")
                                continuation.resume(returning: lessons)
                            }
                        )
                        .store(in: &bag)
                }
            }
    }
}
