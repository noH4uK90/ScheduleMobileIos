//
//  GroupNetworkService.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 4/17/24.
//

import Foundation
import Combine

protocol GroupNetworkProtocol {
    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, Error>
    func getCourseGroups(id: Int) throws -> AnyPublisher<[Grouped<Speciality, Group>], Error>
}

final class GroupNetworkService: GroupNetworkProtocol {
    @Inject private var network: DataTransferProtocol

    func getGroups(search: String, page: Int) throws -> AnyPublisher<PagedList<Group>, any Error> {
        guard let url = GroupEndpoints.group(search, page).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, PagedList<Group>.self)
    }

    func getCourseGroups(id: Int) throws -> AnyPublisher<[Grouped<Speciality, Group>], any Error> {
        guard let url = GroupEndpoints.courseGroups(id).absoluteURL else {
            throw APIError.invalidResponse
        }
        return network.fetch(url, [Grouped<Speciality, Group>].self)
    }
}
