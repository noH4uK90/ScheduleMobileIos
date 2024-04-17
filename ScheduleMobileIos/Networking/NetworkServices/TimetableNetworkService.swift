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
}

final class TimetableNetworkService: TimetableNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getCurrentTimeTable(groupId: Int) throws -> AnyPublisher<PagedList<CurrentTimetable>, any Error> {
        guard let url = TimetableEndpoints.currentTimetable(groupId).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<CurrentTimetable>.self)
    }
}
