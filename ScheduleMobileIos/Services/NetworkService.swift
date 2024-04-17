//
//  NetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/17/23.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, Error>
    func getCurrentTimeTable(groupId: Int) throws -> AnyPublisher<PagedList<CurrentTimetable>, Error>
}

class NetworkService: NetworkProtocol {
    @Inject private var network: DataTransferProtocol

    // MARK: - Group
    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, Error> {
        guard let url = Endpoints.group(search, page).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<Group>.self)
    }

    // MARK: - Schedule
    func getCurrentTimeTable(groupId: Int) throws -> AnyPublisher<PagedList<CurrentTimetable>, Error> {
        guard let url = Endpoints.currentTimetable(groupId).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<CurrentTimetable>.self)
    }
}
